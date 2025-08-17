// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title DroughtProtectedCropContract
 * @dev A smart contract that protects farmers from crop delivery obligations during drought conditions
 * Uses Chainlink oracles for weather data and implements fair compensation mechanisms
 */
contract DroughtProtectedCropContract {
    
    struct CropContract {
        address farmer;
        address buyer;
        uint256 cropAmount; // in kg or bushels
        uint256 pricePerUnit; // in wei
        uint256 deliveryDate;
        uint256 contractDate;
        string location; // coordinates or region identifier
        bool isActive;
        bool isDelivered;
        bool droughtClaimActive;
        uint256 depositAmount;
    }
    
    struct DroughtData {
        uint256 precipitationThreshold; // mm of rainfall over period
        uint256 temperatureThreshold; // temperature in celsius * 100
        uint256 monitoringPeriod; // days to monitor before delivery
        bool droughtDeclared;
        uint256 lastUpdated;
    }
    
    // State variables
    mapping(uint256 => CropContract) public contracts;
    mapping(string => DroughtData) public locationDroughtData;
    mapping(address => bool) public authorizedOracles;
    
    uint256 public contractCounter;
    address public owner;
    uint256 public constant DROUGHT_GRACE_PERIOD = 30 days;
    uint256 public constant MIN_MONITORING_PERIOD = 60 days;
    
    // Events
    event ContractCreated(uint256 indexed contractId, address indexed farmer, address indexed buyer);
    event DroughtDeclared(string indexed location, uint256 timestamp);
    event DroughtClaimActivated(uint256 indexed contractId);
    event ContractVoided(uint256 indexed contractId, string reason);
    event CropDelivered(uint256 indexed contractId);
    event RefundIssued(uint256 indexed contractId, address recipient, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAuthorizedOracle() {
        require(authorizedOracles[msg.sender], "Not an authorized oracle");
        _;
    }
    
    modifier contractExists(uint256 _contractId) {
        require(_contractId < contractCounter, "Contract does not exist");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Create a new crop delivery contract with drought protection
     * @param _buyer Address of the crop buyer
     * @param _cropAmount Amount of crops to be delivered
     * @param _pricePerUnit Price per unit of crop in wei
     * @param _deliveryDate Unix timestamp of delivery date
     * @param _location Location identifier for weather monitoring
     */
    function createContract(
        address _buyer,
        uint256 _cropAmount,
        uint256 _pricePerUnit,
        uint256 _deliveryDate,
        string memory _location
    ) external payable {
        require(_buyer != address(0), "Invalid buyer address");
        require(_cropAmount > 0, "Crop amount must be greater than 0");
        require(_pricePerUnit > 0, "Price per unit must be greater than 0");
        require(_deliveryDate > block.timestamp + MIN_MONITORING_PERIOD, "Delivery date too soon");
        
        uint256 totalContractValue = _cropAmount * _pricePerUnit;
        uint256 requiredDeposit = totalContractValue / 10; // 10% deposit
        require(msg.value >= requiredDeposit, "Insufficient deposit");
        
        contracts[contractCounter] = CropContract({
            farmer: msg.sender,
            buyer: _buyer,
            cropAmount: _cropAmount,
            pricePerUnit: _pricePerUnit,
            deliveryDate: _deliveryDate,
            contractDate: block.timestamp,
            location: _location,
            isActive: true,
            isDelivered: false,
            droughtClaimActive: false,
            depositAmount: msg.value
        });
        
        // Initialize drought monitoring for location if not exists
        if (locationDroughtData[_location].monitoringPeriod == 0) {
            locationDroughtData[_location] = DroughtData({
                precipitationThreshold: 50, // 50mm over monitoring period
                temperatureThreshold: 3500, // 35°C average
                monitoringPeriod: MIN_MONITORING_PERIOD,
                droughtDeclared: false,
                lastUpdated: block.timestamp
            });
        }
        
        emit ContractCreated(contractCounter, msg.sender, _buyer);
        contractCounter++;
    }
    
    /**
     * @dev Buyer pays the full contract amount
     * @param _contractId ID of the contract to pay for
     */
    function payContract(uint256 _contractId) external payable contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.buyer, "Only buyer can pay");
        require(crop.isActive, "Contract is not active");
        
        uint256 totalAmount = crop.cropAmount * crop.pricePerUnit;
        uint256 remainingAmount = totalAmount - crop.depositAmount;
        require(msg.value >= remainingAmount, "Insufficient payment");
        
        // Contract is now fully funded
        emit ContractCreated(_contractId, crop.farmer, crop.buyer);
    }
    
    /**
     * @dev Oracle function to update drought conditions for a location
     * @param _location Location identifier
     * @param _precipitation Recent precipitation in mm
     * @param _avgTemperature Average temperature in celsius * 100
     */
    function updateDroughtData(
        string memory _location,
        uint256 _precipitation,
        uint256 _avgTemperature
    ) external onlyAuthorizedOracle {
        DroughtData storage data = locationDroughtData[_location];
        
        bool isDrought = _precipitation < data.precipitationThreshold || 
                        _avgTemperature > data.temperatureThreshold;
        
        if (isDrought && !data.droughtDeclared) {
            data.droughtDeclared = true;
            emit DroughtDeclared(_location, block.timestamp);
            
            // Activate drought claims for all contracts in this location
            _activateDroughtClaimsForLocation(_location);
        } else if (!isDrought && data.droughtDeclared) {
            data.droughtDeclared = false;
        }
        
        data.lastUpdated = block.timestamp;
    }
    
    /**
     * @dev Internal function to activate drought claims for all contracts in a location
     * @param _location Location identifier
     */
    function _activateDroughtClaimsForLocation(string memory _location) internal {
        for (uint256 i = 0; i < contractCounter; i++) {
            CropContract storage crop = contracts[i];
            if (crop.isActive && 
                !crop.isDelivered && 
                keccak256(bytes(crop.location)) == keccak256(bytes(_location))) {
                
                crop.droughtClaimActive = true;
                emit DroughtClaimActivated(i);
            }
        }
    }
    
    /**
     * @dev Farmer claims drought protection to void contract
     * @param _contractId ID of the contract to claim drought protection
     */
    function claimDroughtProtection(uint256 _contractId) external contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.farmer, "Only farmer can claim drought protection");
        require(crop.isActive, "Contract is not active");
        require(crop.droughtClaimActive, "No active drought claim for this location");
        require(block.timestamp <= crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Claim period expired");
        
        // Void the contract
        crop.isActive = false;
        
        // Return funds to buyer (they get back what they paid)
        uint256 totalContractValue = crop.cropAmount * crop.pricePerUnit;
        uint256 buyerRefund = totalContractValue;
        
        // Farmer loses deposit as compensation to buyer for inconvenience
        uint256 farmerPenalty = crop.depositAmount / 2; // 50% of deposit
        uint256 farmerRefund = crop.depositAmount - farmerPenalty;
        
        // Transfer refunds
        payable(crop.buyer).transfer(buyerRefund + farmerPenalty);
        if (farmerRefund > 0) {
            payable(crop.farmer).transfer(farmerRefund);
        }
        
        emit ContractVoided(_contractId, "Drought protection claimed");
        emit RefundIssued(_contractId, crop.buyer, buyerRefund + farmerPenalty);
    }
    
    /**
     * @dev Farmer delivers crops and completes contract
     * @param _contractId ID of the contract to complete
     */
    function deliverCrops(uint256 _contractId) external contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.farmer, "Only farmer can deliver crops");
        require(crop.isActive, "Contract is not active");
        require(block.timestamp <= crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Delivery period expired");
        
        // Mark as delivered
        crop.isDelivered = true;
        crop.isActive = false;
        
        // Pay farmer the full amount
        uint256 totalPayment = (crop.cropAmount * crop.pricePerUnit) + crop.depositAmount;
        payable(crop.farmer).transfer(totalPayment);
        
        emit CropDelivered(_contractId);
    }
    
    /**
     * @dev Emergency function for buyer to cancel unfulfilled contract after grace period
     * @param _contractId ID of the contract to cancel
     */
    function cancelExpiredContract(uint256 _contractId) external contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.buyer, "Only buyer can cancel");
        require(crop.isActive, "Contract is not active");
        require(block.timestamp > crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Contract not expired");
        require(!crop.isDelivered, "Crops already delivered");
        
        // Cancel contract and refund buyer
        crop.isActive = false;
        
        uint256 totalRefund = (crop.cropAmount * crop.pricePerUnit) + crop.depositAmount;
        payable(crop.buyer).transfer(totalRefund);
        
        emit ContractVoided(_contractId, "Contract expired - cancelled by buyer");
        emit RefundIssued(_contractId, crop.buyer, totalRefund);
    }
    
    /**
     * @dev Add or remove authorized oracles
     * @param _oracle Oracle address
     * @param _authorized Whether to authorize or deauthorize
     */
    function setAuthorizedOracle(address _oracle, bool _authorized) external onlyOwner {
        authorizedOracles[_oracle] = _authorized;
    }
    
    /**
     * @dev Update drought parameters for a location
     * @param _location Location identifier
     * @param _precipitationThreshold Minimum precipitation in mm
     * @param _temperatureThreshold Maximum temperature in celsius * 100
     */
    function updateDroughtParameters(
        string memory _location,
        uint256 _precipitationThreshold,
        uint256 _temperatureThreshold
    ) external onlyOwner {
        DroughtData storage data = locationDroughtData[_location];
        data.precipitationThreshold = _precipitationThreshold;
        data.temperatureThreshold = _temperatureThreshold;
    }
    
    /**
     * @dev Get contract details
     * @param _contractId Contract ID to query
     */
    function getContract(uint256 _contractId) external view contractExists(_contractId) 
        returns (CropContract memory) {
        return contracts[_contractId];
    }
    
    /**
     * @dev Get drought data for a location
     * @param _location Location identifier
     */
    function getDroughtData(string memory _location) external view 
        returns (DroughtData memory) {
        return locationDroughtData[_location];
    }
    
    /**
     * @dev Check if drought is currently declared for a location
     * @param _location Location identifier
     */
    function isDroughtDeclared(string memory _location) external view returns (bool) {
        return locationDroughtData[_location].droughtDeclared;
    }
}
