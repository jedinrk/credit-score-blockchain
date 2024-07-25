// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CreditScore is Ownable {
    uint256 public BLOCK_INTERVAL = 1000;

    struct CreditInfo {
        uint256 transactionVolume;
        uint256 walletBalance;
        uint256 transactionFrequency;
        uint256 transactionMix;
        uint256 newTransactions;
        uint256 creditScore;
        uint256 lastUpdated;
    }

    struct AttributeConfig {
        uint256 minValue;
        uint256 maxValue;
    }

    mapping(address => CreditInfo) public creditInfo;

    // Configuration for each attribute
    AttributeConfig public transactionVolumeConfig =
        AttributeConfig(100, 10000);
    AttributeConfig public walletBalanceConfig =
        AttributeConfig(1 ether, 100 ether);
    AttributeConfig public transactionFrequencyConfig =
        AttributeConfig(10, 1000);
    AttributeConfig public transactionMixConfig = AttributeConfig(1, 10);
    AttributeConfig public newTransactionsConfig = AttributeConfig(1, 10);

    event CheckCreditScore(address indexed user);
    event UpdatedCreditScore(address indexed user, uint256 creditScore);

    modifier validMinMax(uint256 minValue, uint256 maxValue) {
        require(
            minValue <= maxValue,
            "Invalid input: minValue must be less than or equal to maxValue"
        );
        _;
    }

    constructor(address initialOwner) Ownable(initialOwner) {}

    function setBlockInterval(uint256 newInterval) external onlyOwner {
        BLOCK_INTERVAL = newInterval;
    }

    function calculateAttributeScore(
        uint256 value,
        AttributeConfig memory config
    ) internal pure returns (uint256) {
        if (value <= config.minValue) {
            return 0; // Minimum score if value is below or equal to minValue
        } else if (value >= config.maxValue) {
            return 1000; // Maximum score if value is above or equal to maxValue
        } else {
            // Normalize value to a score between 0 and 1000
            return
                ((value - config.minValue) * 1000) /
                (config.maxValue - config.minValue);
        }
    }

    function checkCreditScore(address user) external returns (uint256) {
        CreditInfo storage info = creditInfo[user];

        // Check if lastUpdated is within 1000 blocks
        uint256 blockDifference = block.number - info.lastUpdated;
        if (blockDifference <= BLOCK_INTERVAL) {
            return info.creditScore;
        } else {
            emit CheckCreditScore(user);
            return 0; // Indicate that an update is required
        }
    }

    function updateCreditScore(
        address user,
        uint256 transactionVolume,
        uint256 walletBalance,
        uint256 transactionFrequency,
        uint256 transactionMix,
        uint256 newTransactions
    ) external onlyOwner {
        CreditInfo storage info = creditInfo[user];

        uint256 transactionVolumeScore = calculateAttributeScore(
            transactionVolume,
            transactionVolumeConfig
        );
        uint256 walletBalanceScore = calculateAttributeScore(
            walletBalance,
            walletBalanceConfig
        );
        uint256 transactionFrequencyScore = calculateAttributeScore(
            transactionFrequency,
            transactionFrequencyConfig
        );
        uint256 transactionMixScore = calculateAttributeScore(
            transactionMix,
            transactionMixConfig
        );
        uint256 newTransactionsScore = calculateAttributeScore(
            newTransactions,
            newTransactionsConfig
        );

        info.transactionVolume = transactionVolumeScore;
        info.walletBalance = walletBalanceScore;
        info.transactionFrequency = transactionFrequencyScore;
        info.transactionMix = transactionMixScore;
        info.newTransactions = newTransactionsScore;
        info.lastUpdated = block.number;

        // Calculate the weighted sum
        uint256 weightedSum = ((transactionVolumeScore * 35) +
            (walletBalanceScore * 30) +
            (transactionFrequencyScore * 15) +
            (transactionMixScore * 10) +
            (newTransactionsScore * 10)) / 100;

        // Normalize to range [300, 850]
        uint256 minScore = 300;
        uint256 maxScore = 850;

        info.creditScore =
            ((weightedSum * (maxScore - minScore)) / 1000) +
            minScore;

        emit UpdatedCreditScore(user, info.creditScore);
    }

    function getCreditScore(address user) external view returns (uint256) {
        return creditInfo[user].creditScore;
    }

    function getLastUpdated(address user) external view returns (uint256) {
        return creditInfo[user].lastUpdated;
    }

    // Functions to update the attribute configurations
    function updateTransactionVolumeConfig(
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner validMinMax(minValue, maxValue) {
        transactionVolumeConfig = AttributeConfig(minValue, maxValue);
    }

    function updateWalletBalanceConfig(
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner validMinMax(minValue, maxValue) {
        walletBalanceConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionFrequencyConfig(
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner validMinMax(minValue, maxValue) {
        transactionFrequencyConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionMixConfig(
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner validMinMax(minValue, maxValue) {
        transactionMixConfig = AttributeConfig(minValue, maxValue);
    }

    function updateNewTransactionsConfig(
        uint256 minValue,
        uint256 maxValue
    ) external onlyOwner validMinMax(minValue, maxValue) {
        newTransactionsConfig = AttributeConfig(minValue, maxValue);
    }
}
