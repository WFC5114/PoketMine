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
    mapping(uint256 => uint256) public etherBalances;

    event CreatureMinted(uint256 tokenId, address owner);
    event AttributesUpdated(uint256 tokenId, uint256 level, uint256 experience, uint256 cryptoBound);
    event CreatureTraded(uint256 tokenId, address from, address to);
    event LevelUp(uint256 tokenId, uint256 newLevel);
    event EtherDeposited(uint256 tokenId, uint256 amount, address depositor);
    event EtherWithdrawn(uint256 tokenId, uint256 amount, address recipient);

    constructor(string memory name, string memory symbol, address initialOwner) ERC721(name, symbol) Ownable(initialOwner) {}

    function mintCreature(address player, string memory tokenURI) public onlyOwner {
        uint256 newTokenId = _currentTokenId + 1;
        _mint(player, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        creatureAttributes[newTokenId] = CreatureAttributes(1, 0, 0); // Default starting attributes
        _currentTokenId = newTokenId;

        emit CreatureMinted(newTokenId, player);
    }

    function depositEtherToCreature(uint256 tokenId) public payable {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        etherBalances[tokenId] += msg.value;
        increaseExperience(tokenId, msg.value);
        emit EtherDeposited(tokenId, msg.value, msg.sender);
    }

    function withdrawEther(uint256 tokenId, uint256 amount) public {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        require(etherBalances[tokenId] >= amount, "Insufficient balance.");

        etherBalances[tokenId] -= amount;
        decreaseExperience(tokenId, amount);
        payable(msg.sender).transfer(amount);
        emit EtherWithdrawn(tokenId, amount, msg.sender);
    }

    function increaseExperience(uint256 tokenId, uint256 ethAmount) internal {
        uint256 experienceToAdd = ethAmount * 100000;
        creatureAttributes[tokenId].experience += experienceToAdd;
        levelUp(tokenId);
    }

    function decreaseExperience(uint256 tokenId, uint256 ethAmount) internal {
        uint256 experienceToSubtract = ethAmount * 100000;
        if (creatureAttributes[tokenId].experience > experienceToSubtract) {
            creatureAttributes[tokenId].experience -= experienceToSubtract;
        } else {
            creatureAttributes[tokenId].experience = 0;
        }
        levelUp(tokenId);
    }

    function levelUp(uint256 tokenId) internal {
        while (creatureAttributes[tokenId].level < 10 && 
               creatureAttributes[tokenId].experience >= getNextLevelExperience(creatureAttributes[tokenId].level)) {
            creatureAttributes[tokenId].level++;
            emit LevelUp(tokenId, creatureAttributes[tokenId].level);
        }
    }

    function getNextLevelExperience(uint256 currentLevel) public pure returns (uint256) {
        return (currentLevel + 1) * (currentLevel + 1) * 100000;
    }

    // Fallback function to accept ETH when sent to the contract address directly
    receive() external payable {
        emit EtherDeposited(0, msg.value, msg.sender);  // tokenId is 0 as no specific NFT is targeted
    }
}
