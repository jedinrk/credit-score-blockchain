// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CreditScore is Ownable {
    // Interval of blocks within which the credit score is considered up-to-date
    uint256 public BLOCK_INTERVAL = 1000;

    struct CreditInfo {
        uint256 transactionVolume;    // Score for transaction volume
        uint256 walletBalance;        // Score for wallet balance
        uint256 transactionFrequency; // Score for transaction frequency
        uint256 transactionMix;       // Score for transaction mix
        uint256 newTransactions;      // Score for new transactions
        uint256 creditScore;          // Calculated credit score
        uint256 lastUpdated;          // Last block number when the credit score was updated
    }

    // AttributeConfig hold configuration for mininum and maximum score for each credit score element
    struct AttributeConfig {
        uint256 minValue; // Minimum value for the attribute
        uint256 maxValue; // Maximum value for the attribute
    }

    // Mapping from user address to their credit information
    mapping(address => CreditInfo) public creditInfo;

    // Configuration for credit score element
    AttributeConfig public transactionVolumeConfig = AttributeConfig(100, 10000);
    AttributeConfig public walletBalanceConfig = AttributeConfig(1 ether, 100 ether);
    AttributeConfig public transactionFrequencyConfig = AttributeConfig(10, 1000);
    AttributeConfig public transactionMixConfig = AttributeConfig(1, 10);
    AttributeConfig public newTransactionsConfig = AttributeConfig(1, 10);

    // Event emitted when a credit score check is requested
    event CheckCreditScore(address indexed user);
    // Event emitted when a credit score is updated
    event UpdatedCreditScore(address indexed user, uint256 creditScore);

    // Modifier to validate minimum and maximum values
    modifier validMinMax(uint256 minValue, uint256 maxValue) {
        require(minValue <= maxValue, "Invalid input: minValue must be less than or equal to maxValue");
        _;
    }

    constructor(address initialOwner) Ownable(initialOwner) {}

    // Function to set a new block interval for credit score validity
    function setBlockInterval(uint256 newInterval) external onlyOwner {
        BLOCK_INTERVAL = newInterval;
    }

    /* Function to calculate the each credit score element based on its value and configuration. The range of score is set to [0-1000].
       This is an internal function
    */
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

    // Function to check the credit score of a user
    function checkCreditScore(address user) external returns (uint256) {
        CreditInfo storage info = creditInfo[user];

        // Check if lastUpdated is within the block interval
        uint256 blockDifference = block.number - info.lastUpdated;
        if (blockDifference <= BLOCK_INTERVAL) {
            return info.creditScore; // Return the existing credit score
        } else {
            emit CheckCreditScore(user); // Emit event to indicate that an update is required
            return 0; // Indicate that an update is required
        }
    }

    function updateTransactionVolume(address user, uint256 transactionVolume) external onlyOwner {
        CreditInfo storage info = creditInfo[user];
        info.transactionVolume = calculateAttributeScore(transactionVolume, transactionVolumeConfig);
        updateCreditScore(user); // Update the overall credit score
    }

    function updateWalletBalance(address user, uint256 walletBalance) external onlyOwner {
        CreditInfo storage info = creditInfo[user];
        info.walletBalance = calculateAttributeScore(walletBalance, walletBalanceConfig);
        updateCreditScore(user); // Update the overall credit score
    }

    function updateTransactionFrequency(address user, uint256 transactionFrequency) external onlyOwner {
        CreditInfo storage info = creditInfo[user];
        info.transactionFrequency = calculateAttributeScore(transactionFrequency, transactionFrequencyConfig);
        updateCreditScore(user); // Update the overall credit score
    }

    function updateTransactionMix(address user, uint256 transactionMix) external onlyOwner {
        CreditInfo storage info = creditInfo[user];
        info.transactionMix = calculateAttributeScore(transactionMix, transactionMixConfig);
        updateCreditScore(user); // Update the overall credit score
    }

    // Function to update the new transactions score of a user
    function updateNewTransactions(address user, uint256 newTransactions) external onlyOwner {
        CreditInfo storage info = creditInfo[user];
        info.newTransactions = calculateAttributeScore(newTransactions, newTransactionsConfig);
        updateCreditScore(user); // Update the overall credit score
    }

    // Function to calculate and update the overall credit score of a user
    function updateCreditScore(address user) public onlyOwner {
        CreditInfo storage info = creditInfo[user];

        // Calculate the weighted sum of credit score elements
        uint256 weightedSum = ((info.transactionVolume * 35) +
                               (info.walletBalance * 30) +
                               (info.transactionFrequency * 15) +
                               (info.transactionMix * 10) +
                               (info.newTransactions * 10)) / 100;

        // Normalize the weighted sum to a credit score range of [300, 850]
        uint256 minScore = 300;
        uint256 maxScore = 850;
        info.creditScore = ((weightedSum * (maxScore - minScore)) / 1000) + minScore;
        info.lastUpdated = block.number; // Update the last updated block number

        emit UpdatedCreditScore(user, info.creditScore); // Emit event for updated credit score
    }

    
    function getCreditScore(address user) external view returns (uint256) {
        return creditInfo[user].creditScore;
    }

    
    // Functions to update the each credit score elements
    function updateTransactionVolumeConfig(uint256 minValue, uint256 maxValue)
        external
        onlyOwner
        validMinMax(minValue, maxValue)
    {
        transactionVolumeConfig = AttributeConfig(minValue, maxValue);
    }

    function updateWalletBalanceConfig(uint256 minValue, uint256 maxValue)
        external
        onlyOwner
        validMinMax(minValue, maxValue)
    {
        walletBalanceConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionFrequencyConfig(uint256 minValue, uint256 maxValue)
        external
        onlyOwner
        validMinMax(minValue, maxValue)
    {
        transactionFrequencyConfig = AttributeConfig(minValue, maxValue);
    }

    function updateTransactionMixConfig(uint256 minValue, uint256 maxValue)
        external
        onlyOwner
        validMinMax(minValue, maxValue)
    {
        transactionMixConfig = AttributeConfig(minValue, maxValue);
    }

    function updateNewTransactionsConfig(uint256 minValue, uint256 maxValue)
        external
        onlyOwner
        validMinMax(minValue, maxValue)
    {
        newTransactionsConfig = AttributeConfig(minValue, maxValue);
    }
}
