// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title DroughtProtectedCropContract - Remix Test Version
 * @dev Simplified version for testing in Remix IDE without external oracles
 * Uses manual drought declaration for testing purposes
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
    
    // Testing variables
    uint256 public testTimestamp;
    bool public useTestTime;
    
    // Events
    event ContractCreated(uint256 indexed contractId, address indexed farmer, address indexed buyer, uint256 amount);
    event DroughtDeclared(string indexed location, uint256 timestamp);
    event DroughtClaimActivated(uint256 indexed contractId);
    event ContractVoided(uint256 indexed contractId, string reason);
    event CropDelivered(uint256 indexed contractId, uint256 amount);
    event RefundIssued(uint256 indexed contractId, address recipient, uint256 amount);
    event PaymentReceived(address from, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAuthorizedOracle() {
        require(authorizedOracles[msg.sender] || msg.sender == owner, "Not an authorized oracle");
        _;
    }
    
    modifier contractExists(uint256 _contractId) {
        require(_contractId < contractCounter, "Contract does not exist");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        authorizedOracles[msg.sender] = true; // Owner is default oracle for testing
        testTimestamp = block.timestamp;
        useTestTime = true;
    }
    
    // Testing function to simulate time passage
    function advanceTime(uint256 _seconds) external onlyOwner {
        testTimestamp += _seconds;
    }
    
    function getCurrentTime() public view returns (uint256) {
        return useTestTime ? testTimestamp : block.timestamp;
    }
    
    function toggleTestMode() external onlyOwner {
        useTestTime = !useTestTime;
    }
    
    /**
     * @dev Create a new crop delivery contract with drought protection
     * @param _buyer Address of the crop buyer
     * @param _cropAmount Amount of crops to be delivered
     * @param _pricePerUnit Price per unit of crop in wei
     * @param _deliveryDays Days from now for delivery
     * @param _location Location identifier for weather monitoring
     */
    function createContract(
        address _buyer,
        uint256 _cropAmount,
        uint256 _pricePerUnit,
        uint256 _deliveryDays, // Changed to days for easier testing
        string memory _location
    ) external payable {
        require(_buyer != address(0), "Invalid buyer address");
        require(_buyer != msg.sender, "Buyer cannot be farmer");
        require(_cropAmount > 0, "Crop amount must be greater than 0");
        require(_pricePerUnit > 0, "Price per unit must be greater than 0");
        require(_deliveryDays >= 1, "Delivery must be at least 1 day away");
        
        uint256 deliveryDate = getCurrentTime() + (_deliveryDays * 1 days);
        uint256 totalContractValue = _cropAmount * _pricePerUnit;
        uint256 requiredDeposit = totalContractValue / 10; // 10% deposit
        require(msg.value >= requiredDeposit, "Insufficient deposit");
        
        contracts[contractCounter] = CropContract({
            farmer: msg.sender,
            buyer: _buyer,
            cropAmount: _cropAmount,
            pricePerUnit: _pricePerUnit,
            deliveryDate: deliveryDate,
            contractDate: getCurrentTime(),
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
                lastUpdated: getCurrentTime()
            });
        }
        
        emit ContractCreated(contractCounter, msg.sender, _buyer, totalContractValue);
        emit PaymentReceived(msg.sender, msg.value);
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
        require(msg.value >= totalAmount, "Insufficient payment");
        
        emit PaymentReceived(msg.sender, msg.value);
    }
    
    /**
     * @dev Manually declare drought for testing (simplified oracle function)
     * @param _location Location identifier
     * @param _isDrought Whether to declare drought or not
     */
    function declaredrought(string memory _location, bool _isDrought) external onlyAuthorizedOracle {
        DroughtData storage data = locationDroughtData[_location];
        
        if (_isDrought && !data.droughtDeclared) {
            data.droughtDeclared = true;
            emit DroughtDeclared(_location, getCurrentTime());
            
            // Activate drought claims for all contracts in this location
            _activateDroughtClaimsForLocation(_location);
        } else if (!_isDrought && data.droughtDeclared) {
            data.droughtDeclared = false;
        }
        
        data.lastUpdated = getCurrentTime();
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
        require(getCurrentTime() <= crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Claim period expired");
        
        // Void the contract
        crop.isActive = false;
        
        // Calculate refunds
        uint256 totalContractValue = crop.cropAmount * crop.pricePerUnit;
        uint256 buyerRefund = totalContractValue;
        
        // Farmer loses 50% of deposit as compensation to buyer
        uint256 farmerPenalty = crop.depositAmount / 2;
        uint256 farmerRefund = crop.depositAmount - farmerPenalty;
        
        // Transfer refunds
        if (buyerRefund + farmerPenalty > 0) {
            payable(crop.buyer).transfer(buyerRefund + farmerPenalty);
            emit RefundIssued(_contractId, crop.buyer, buyerRefund + farmerPenalty);
        }
        
        if (farmerRefund > 0) {
            payable(crop.farmer).transfer(farmerRefund);
            emit RefundIssued(_contractId, crop.farmer, farmerRefund);
        }
        
        emit ContractVoided(_contractId, "Drought protection claimed");
    }
    
    /**
     * @dev Farmer delivers crops and completes contract
     * @param _contractId ID of the contract to complete
     */
    function deliverCrops(uint256 _contractId) external contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.farmer, "Only farmer can deliver crops");
        require(crop.isActive, "Contract is not active");
        require(getCurrentTime() <= crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Delivery period expired");
        
        // Mark as delivered
        crop.isDelivered = true;
        crop.isActive = false;
        
        // Pay farmer the full contract amount plus their deposit back
        uint256 contractValue = crop.cropAmount * crop.pricePerUnit;
        uint256 totalPayment = contractValue + crop.depositAmount;
        
        require(address(this).balance >= totalPayment, "Insufficient contract balance");
        payable(crop.farmer).transfer(totalPayment);
        
        emit CropDelivered(_contractId, totalPayment);
    }
    
    /**
     * @dev Emergency function for buyer to cancel unfulfilled contract after grace period
     * @param _contractId ID of the contract to cancel
     */
    function cancelExpiredContract(uint256 _contractId) external contractExists(_contractId) {
        CropContract storage crop = contracts[_contractId];
        require(msg.sender == crop.buyer, "Only buyer can cancel");
        require(crop.isActive, "Contract is not active");
        require(getCurrentTime() > crop.deliveryDate + DROUGHT_GRACE_PERIOD, "Contract not expired");
        require(!crop.isDelivered, "Crops already delivered");
        
        // Cancel contract and refund buyer everything
        crop.isActive = false;
        
        uint256 totalRefund = (crop.cropAmount * crop.pricePerUnit) + crop.depositAmount;
        require(address(this).balance >= totalRefund, "Insufficient contract balance");
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
    
    // View functions for testing
    function getContract(uint256 _contractId) external view contractExists(_contractId) 
        returns (
            address farmer,
            address buyer,
            uint256 cropAmount,
            uint256 pricePerUnit,
            uint256 deliveryDate,
            string memory location,
            bool isActive,
            bool isDelivered,
            bool droughtClaimActive,
            uint256 depositAmount
        ) {
        CropContract memory c = contracts[_contractId];
        return (
            c.farmer,
            c.buyer,
            c.cropAmount,
            c.pricePerUnit,
            c.deliveryDate,
            c.location,
            c.isActive,
            c.isDelivered,
            c.droughtClaimActive,
            c.depositAmount
        );
    }
    
    function getDroughtData(string memory _location) external view 
        returns (
            uint256 precipitationThreshold,
            uint256 temperatureThreshold,
            uint256 monitoringPeriod,
            bool droughtDeclared,
            uint256 lastUpdated
        ) {
        DroughtData memory d = locationDroughtData[_location];
        return (
            d.precipitationThreshold,
            d.temperatureThreshold,
            d.monitoringPeriod,
            d.droughtDeclared,
            d.lastUpdated
        );
    }
    
    function isDroughtDeclared(string memory _location) external view returns (bool) {
        return locationDroughtData[_location].droughtDeclared;
    }
    
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function getContractCount() external view returns (uint256) {
        return contractCounter;
    }
}
