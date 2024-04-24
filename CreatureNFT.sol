// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatureNFT is ERC721URIStorage, Ownable {
    uint256 private _currentTokenId = 0;

    struct CreatureAttributes {
        uint256 level;
        uint256 experience;
        uint256 cryptoBound;
    }

    mapping(uint256 => CreatureAttributes) public creatureAttributes;

    event CreatureMinted(uint256 tokenId, address owner);
    event AttributesUpdated(uint256 tokenId, uint256 level, uint256 experience, uint256 cryptoBound);
    event CreatureTraded(uint256 tokenId, address from, address to);
    event LevelUp(uint256 tokenId, uint256 newLevel);

    // Pass the initial owner address to the Ownable constructor
    constructor(address initialOwner) ERC721("CreatureNFT", "CNFT") Ownable(initialOwner) {}

    function mintCreature(address player, string memory tokenURI) public onlyOwner {
        uint256 newTokenId = _currentTokenId + 1;
        _mint(player, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        creatureAttributes[newTokenId] = CreatureAttributes(1, 0, 0); // Default starting attributes
        _currentTokenId = newTokenId;

        emit CreatureMinted(newTokenId, player);
    }

    function updateCreatureAttributes(uint256 tokenId, uint256 experienceGained, uint256 cryptoToBind) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner of the NFT");
        CreatureAttributes storage attributes = creatureAttributes[tokenId];
        attributes.experience += experienceGained;
        attributes.cryptoBound += cryptoToBind;

        // Check if the creature should level up
        if (attributes.experience >= getRequiredExperience(attributes.level)) {
            attributes.level++;
            attributes.experience = 0; // Optionally reset experience after leveling up
            emit LevelUp(tokenId, attributes.level);
        }

        emit AttributesUpdated(tokenId, attributes.level, attributes.experience, attributes.cryptoBound);
    }

        function convertCryptoToExperience(uint256 cryptoAmount) public pure returns (uint256) {
        //conversion rate: 1 crypto = 10 experience points
        return cryptoAmount * 10;
    }

    function getRequiredExperience(uint256 level) public pure returns (uint256) {
        // Define how experience requirements scale with levels
        return (level + 1) * 100; // Reasonable scaling
    }

    // Override the standard ERC721 transfer function to add custom logic
    function safeTransferCreature(address from, address to, uint256 tokenId) public {
        emit CreatureTraded(tokenId, from, to);
        safeTransferFrom(from, to, tokenId);
    }
}

