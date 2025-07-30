// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BitCornNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("BitCorn", "CORN") {}

    struct Trait {
        string trait_type;
        string value;
    }

    struct BitCornMetadata {
        string name;
        string description;
        string category;
        string target_trait;
        string lineage;
        string image;
        string id;
        string[] parent_ids;
        uint256 seed_ts;
        uint256 a_shares_ts;
        uint256 b_shares_ts;
        Trait[] traits;
    }

    mapping(uint256 => BitCornMetadata) private tokenMetadata;

    function mintBitCornNFT(
        address recipient,
        string memory tokenURI,
        BitCornMetadata memory metadata
    ) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        tokenMetadata[newItemId] = metadata;

        return newItemId;
    }

    function getMetadata(uint256 tokenId) public view returns (BitCornMetadata memory) {
        require(_exists(tokenId), "Token does not exist");
        return tokenMetadata[tokenId];
    }

    function updateBSharesTimestamp(uint256 tokenId, uint256 newTimestamp) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        tokenMetadata[tokenId].b_shares_ts = newTimestamp;
    }

    function updateTraits(uint256 tokenId, Trait[] memory newTraits) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        delete tokenMetadata[tokenId].traits;
        for (uint i = 0; i < newTraits.length; i++) {
            tokenMetadata[tokenId].traits.push(newTraits[i]);
        }
    }
}
