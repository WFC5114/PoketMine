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

    function depositEther(uint256 tokenId) public payable {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        etherBalances[tokenId] += msg.value;
        emit EtherDeposited(tokenId, msg.value, msg.sender);
    }

    function withdrawEther(uint256 tokenId, uint256 amount) public {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        require(etherBalances[tokenId] >= amount, "Insufficient balance.");

        etherBalances[tokenId] -= amount;
        payable(msg.sender).transfer(amount);
        emit EtherWithdrawn(tokenId, amount, msg.sender);
    }

    function safeTransferCreature(address from, address to, uint256 tokenId) public {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        
        safeTransferFrom(from, to, tokenId);
        uint256 balance = etherBalances[tokenId];
        etherBalances[tokenId] = 0;
        if (balance > 0) {
            payable(to).transfer(balance);
        }
        emit CreatureTraded(tokenId, from, to);
    }
}
