// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CreditScore {
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
    AttributeConfig public transactionVolumeConfig = AttributeConfig(100, 10000);
    AttributeConfig public walletBalanceConfig = AttributeConfig(1 ether, 100 ether);
    AttributeConfig public transactionFrequencyConfig = AttributeConfig(10, 1000);
    AttributeConfig public transactionMixConfig = AttributeConfig(1, 10);
    AttributeConfig public newTransactionsConfig = AttributeConfig(1, 10);

    event CheckCreditScore(address indexed user);

    function calculateAttributeScore(uint256 value, AttributeConfig memory config) internal pure returns (uint256) {
        if (value <= config.minValue) {
            return 0; // Minimum score if value is below or equal to minValue
        } else if (value >= config.maxValue) {
            return 1000; // Maximum score if value is above or equal to maxValue
        } else {
            // Normalize value to a score between 0 and 1000
            return ((value - config.minValue) * 1000) / (config.maxValue - config.minValue);
        }
    }

    function updateCreditInfo(
        address user,
        uint256 transactionVolume,
        uint256 walletBalance,
        uint256 transactionFrequency,
        uint256 transactionMix,
        uint256 newTransactions
    ) external {
        CreditInfo storage info = creditInfo[user];

        uint256 transactionVolumeScore = calculateAttributeScore(transactionVolume, transactionVolumeConfig);
        uint256 walletBalanceScore = calculateAttributeScore(walletBalance, walletBalanceConfig);
        uint256 transactionFrequencyScore = calculateAttributeScore(transactionFrequency, transactionFrequencyConfig);
        uint256 transactionMixScore = calculateAttributeScore(transactionMix, transactionMixConfig);
        uint256 newTransactionsScore = calculateAttributeScore(newTransactions, newTransactionsConfig);

        info.transactionVolume = transactionVolumeScore;
        info.walletBalance = walletBalanceScore;
        info.transactionFrequency = transactionFrequencyScore;
        info.transactionMix = transactionMixScore;
        info.newTransactions = newTransactionsScore;
        info.lastUpdated = block.timestamp;

        // Calculate the weighted sum
        uint256 weightedSum = ((transactionVolumeScore * 35) +
                               (walletBalanceScore * 30) +
                               (transactionFrequencyScore * 15) +
                               (transactionMixScore * 10) +
                               (newTransactionsScore * 10)) / 100;

        // Normalize to range [300, 850]
        uint256 minScore = 300;
        uint256 maxScore = 850;
        
        info.creditScore = ((weightedSum * (maxScore - minScore)) / 1000) + minScore;

        emit CheckCreditScore(user);
    }

    function getCreditScore(address user) external view returns (uint256) {
        return creditInfo[user].creditScore;
    }

    function getLastUpdated(address user) external view returns (uint256) {
        return creditInfo[user].lastUpdated;
    }

    // Functions to update the attribute configurations
    function updateTransactionVolumeConfig(uint256 minValue, uint256 maxValue) external {
        transactionVolumeConfig = AttributeConfig(minValue, maxValue);
    }

    function updateWalletBalanceConfig(uint256 minValue, uint256 maxValue) external {
        walletBalanceConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionFrequencyConfig(uint256 minValue, uint256 maxValue) external {
        transactionFrequencyConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionMixConfig(uint256 minValue, uint256 maxValue) external {
        transactionMixConfig = AttributeConfig(minValue, maxValue);
    }

    function updateNewTransactionsConfig(uint256 minValue, uint256 maxValue) external {
        newTransactionsConfig = AttributeConfig(minValue, maxValue);
    }
}
