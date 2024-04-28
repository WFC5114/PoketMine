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
    event AttributesUpdated(
        uint256 tokenId,
        uint256 level,
        uint256 experience,
        uint256 cryptoBound
    );
    event CreatureTraded(uint256 tokenId, address from, address to);
    event LevelUp(uint256 tokenId, uint256 newLevel);
    event EtherDeposited(uint256 tokenId, uint256 amount, address depositor);
    event EtherWithdrawn(uint256 tokenId, uint256 amount, address recipient);

    constructor(
        string memory name,
        string memory symbol,
        address initialOwner
    ) ERC721(name, symbol) Ownable(initialOwner) {}

    function mintCreature(address player, string memory tokenURI)
        public
        onlyOwner
    {
        uint256 newTokenId = _currentTokenId + 1;
        _mint(player, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
<<<<<<< Updated upstream
        creatureAttributes[newTokenId] = CreatureAttributes(0, 0, 0); // Default starting attributes set to level 0
=======
        creatureAttributes[newTokenId] = CreatureAttributes(0, 0, 1000, 0); // Default starting attributes set to level 0
>>>>>>> Stashed changes
        _currentTokenId = newTokenId;

        emit CreatureMinted(newTokenId, player);
    }


    function depositEtherToCreature(uint256 tokenId) public payable {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
<<<<<<< Updated upstream

        etherBalances[tokenId] += msg.value;  // 更新该tokenId的以太币余额记录
        creatureAttributes[tokenId].cryptoBound += msg.value;  // 直接使用msg.value更新cryptoBound

        increaseExperience(tokenId);  // 基于更新后的cryptoBound重新计算经验值
        emit EtherDeposited(tokenId, msg.value, msg.sender);
    }

=======
        etherBalances[tokenId] += msg.value;
        creatureAttributes[tokenId].cryptoBound += msg.value;
        updateExperienceAndLevel(tokenId, msg.value);
        emit EtherDeposited(tokenId, msg.value, msg.sender);
    }

    function updateExperienceAndLevel(uint256 tokenId, uint256 amountDeposited)
        internal
    {
        CreatureAttributes storage attrs = creatureAttributes[tokenId];
        if (attrs.level < 10) {
            attrs.experience += (amountDeposited * 200) / 1e15;
            calculateLevel(tokenId);
        }
    }

    function calculateLevel(uint256 tokenId) internal {
        CreatureAttributes storage attrs = creatureAttributes[tokenId];
        while (
            attrs.experience >= attrs.nextLevelExperience && attrs.level < 10
        ) {
            attrs.level++;
            attrs.experience -= attrs.nextLevelExperience;
            attrs.nextLevelExperience = getNextLevelExperience(attrs.level);
        }
        if (attrs.level == 10) {
            attrs.nextLevelExperience = 0; // No more experience required after max level
        }
        emit LevelUp(tokenId, attrs.level);
    }
>>>>>>> Stashed changes

    function withdrawEther(uint256 tokenId, uint256 amount) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner.");
        require(etherBalances[tokenId] >= amount, "Insufficient balance.");
<<<<<<< Updated upstream
        require(creatureAttributes[tokenId].cryptoBound >= amount, "Insufficient crypto bound.");
=======
        require(
            creatureAttributes[tokenId].cryptoBound >= amount,
            "Insufficient crypto bound."
        );
>>>>>>> Stashed changes

        etherBalances[tokenId] -= amount;
        creatureAttributes[tokenId].cryptoBound -= amount;
        decreaseExperience(tokenId); // 直接根据cryptoBound更新经验值
        payable(msg.sender).transfer(amount);
        emit EtherWithdrawn(tokenId, amount, msg.sender);
    }

<<<<<<< Updated upstream

    function increaseExperience(uint256 tokenId) internal {
        uint256 experienceToAdd = creatureAttributes[tokenId].cryptoBound * 1000000;
=======
    function increaseExperience(uint256 tokenId) internal {
        uint256 experienceToAdd = creatureAttributes[tokenId].cryptoBound *
            1000000;
>>>>>>> Stashed changes
        creatureAttributes[tokenId].experience = experienceToAdd;
        levelUp(tokenId);
    }

<<<<<<< Updated upstream


    function decreaseExperience(uint256 tokenId) internal {
        uint256 experienceToSubtract = creatureAttributes[tokenId].cryptoBound * 1000000;
=======
    function decreaseExperience(uint256 tokenId) internal {
        uint256 experienceToSubtract = creatureAttributes[tokenId].cryptoBound *
            1000000;
>>>>>>> Stashed changes
        creatureAttributes[tokenId].experience = experienceToSubtract;
        levelUp(tokenId);
    }

    function levelUp(uint256 tokenId) internal {
<<<<<<< Updated upstream
        uint256 currentExperience = creatureAttributes[tokenId].cryptoBound * 1000000;
        uint256 level = 0;
        while (level < 10 && currentExperience >= getNextLevelExperience(level)) {
=======
        uint256 currentExperience = creatureAttributes[tokenId].cryptoBound *
            1000000;
        uint256 level = 0;
        while (
            level < 10 && currentExperience >= getNextLevelExperience(level)
        ) {
>>>>>>> Stashed changes
            currentExperience -= getNextLevelExperience(level);
            level++;
        }
        creatureAttributes[tokenId].level = level;
        if (creatureAttributes[tokenId].level == 10) {
            // 如果达到最大等级，可能需要处理特殊逻辑
        }
        emit LevelUp(tokenId, creatureAttributes[tokenId].level);
    }

<<<<<<< Updated upstream
    function getNextLevelExperience(uint256 currentLevel) public pure returns (uint256) {
        uint256 baseExperience = 10000; // 基础经验值为10,000点
        uint256 factor = 1100; // 1.1倍增长，放大1000倍处理
        uint256 result = baseExperience * 1000; // 初始放大1000倍处理

        for (uint256 i = 0; i < currentLevel; i++) {
            result = (result * factor) / 1000;
        }

        return result / 1000; // 缩放回实际大小
=======
    function getNextLevelExperience(uint256 currentLevel)
        public
        pure
        returns (uint256)
    {
        if (currentLevel >= 10) return 0; // No more levels after 10
        uint256 baseExperience = 1000;
        return baseExperience * (1 << currentLevel); // Double the requirement for each level up
    }

    function safeTransferCreature(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");

        // 转移NFT
        safeTransferFrom(from, to, tokenId);

        // 同时转移绑定的以太币
        uint256 balance = etherBalances[tokenId];
        if (balance > 0) {
            etherBalances[tokenId] = 0;
            (bool sent, ) = to.call{value: balance}("");
            require(sent, "Failed to send Ether");
        }

        emit CreatureTraded(tokenId, from, to);
    }

    function getCreatureDetails(uint256 tokenId)
        public
        view
        returns (CreatureAttributes memory attributes, uint256 etherBalance)
    {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        attributes = creatureAttributes[tokenId];
        etherBalance = etherBalances[tokenId];
        return (attributes, etherBalance);
>>>>>>> Stashed changes
    }



    function safeTransferCreature(address from, address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");

        // 转移NFT
        safeTransferFrom(from, to, tokenId);

        // 同时转移绑定的以太币
        uint256 balance = etherBalances[tokenId];
        if (balance > 0) {
            etherBalances[tokenId] = 0;
            (bool sent, ) = to.call{value: balance}("");
            require(sent, "Failed to send Ether");
        }

        emit CreatureTraded(tokenId, from, to);
    }

    function getCreatureDetails(uint256 tokenId) public view returns (CreatureAttributes memory attributes, uint256 etherBalance) {
        require(ownerOf(tokenId) != address(0), "Creature does not exist.");
        return (creatureAttributes[tokenId], etherBalances[tokenId]);
    }


    // Fallback function to accept ETH when sent to the contract address directly
    receive() external payable {
        emit EtherDeposited(0, msg.value, msg.sender); // tokenId is 0 as no specific NFT is targeted
    }
}