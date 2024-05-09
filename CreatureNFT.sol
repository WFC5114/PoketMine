// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatureNFT is ERC721URIStorage, Ownable {
    uint256 private _currentTokenId = 0;

    struct CreatureAttributes {
        uint256 level;
        uint256 experience;
        uint256 nextLevelExperience;
        uint256 cryptoBound;
    }

    mapping(uint256 => CreatureAttributes) public creatureAttributes;
    mapping(uint256 => uint256) public etherBalances;

    event CreatureMinted(uint256 tokenId, address owner);
    event AttributesUpdated(uint256 tokenId, uint256 level, uint256 experience, uint256 nextLevelExperience, uint256 cryptoBound);
    event CreatureTraded(uint256 tokenId, address from, address to);
    event LevelUp(uint256 tokenId, uint256 newLevel);
    event EtherDeposited(uint256 tokenId, uint256 amount, address depositor);
    event EtherWithdrawn(uint256 tokenId, uint256 amount, address recipient);

    constructor(string memory name, string memory symbol, address initialOwner)
        ERC721(name, symbol)
        Ownable(initialOwner)
    {}

    function mintCreature(address player, string memory tokenURI)
        public
        onlyOwner
    {
        uint256 newTokenId = _currentTokenId + 1;
        _mint(player, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        creatureAttributes[newTokenId] = CreatureAttributes(0, 0, 1000, 0); // 初始等级为0，经验值为0，下一等级经验值1000，绑定以太币为0
        _currentTokenId = newTokenId;

        emit CreatureMinted(newTokenId, player);
    }

    function depositEtherToCreature(uint256 tokenId) public payable {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        etherBalances[tokenId] += msg.value;
        creatureAttributes[tokenId].cryptoBound += msg.value;
        updateAttributes(tokenId);
        emit EtherDeposited(tokenId, msg.value, msg.sender);
    }

    function withdrawEther(uint256 tokenId, uint256 amount) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        require(etherBalances[tokenId] >= amount, "Insufficient balance.");
        require(creatureAttributes[tokenId].cryptoBound >= amount, "Insufficient crypto bound.");

        etherBalances[tokenId] -= amount;
        creatureAttributes[tokenId].cryptoBound -= amount;
        updateAttributes(tokenId);

        payable(msg.sender).transfer(amount);
        emit EtherWithdrawn(tokenId, amount, msg.sender);
    }

    function updateAttributes(uint256 tokenId) internal {
        CreatureAttributes storage attrs = creatureAttributes[tokenId];

        // 每1以太币等价1000经验值
        attrs.experience = (attrs.cryptoBound * 100000) / 1e18;

        // 计算等级和下一等级经验
        uint256 currentLevel = 0;
        uint256 currentExperience = attrs.experience;

        while (currentExperience >= getNextLevelExperience(currentLevel) && currentLevel < 10) {
            currentExperience -= getNextLevelExperience(currentLevel);
            currentLevel++;
        }

        attrs.level = currentLevel;

        if (currentLevel < 10) {
            attrs.nextLevelExperience = getNextLevelExperience(currentLevel) - currentExperience;
        } else {
            attrs.nextLevelExperience = 0; // 达到10级后不再升级
        }

        emit LevelUp(tokenId, attrs.level);
        emit AttributesUpdated(tokenId, attrs.level, attrs.experience, attrs.nextLevelExperience, attrs.cryptoBound);
    }

    function getNextLevelExperience(uint256 currentLevel) public pure returns (uint256) {
        if (currentLevel >= 10) return 0; // 达到10级后不再升级
        uint256 baseExperience = 1000;
        return baseExperience * (1 << currentLevel); // 每升一级经验需求翻倍
    }

    function getCreatureDetails(uint256 tokenId) public view returns (CreatureAttributes memory attributes, uint256 etherBalance) {
        require(ownerOf(tokenId) !=address(0), "Creature does not exist.");
        attributes = creatureAttributes[tokenId];
        etherBalance = etherBalances[tokenId];
        return (attributes, etherBalance);
    }

    receive() external payable {
        emit EtherDeposited(0, msg.value, msg.sender); // tokenId 为 0，因为没有特定的 NFT 被针对
    }
}
