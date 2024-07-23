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

    mapping(address => CreditInfo) public creditInfo;

    event CheckCreditScore(address indexed user);

    function updateCreditInfo(
        address user,
        uint256 transactionVolume,
        uint256 walletBalance,
        uint256 transactionFrequency,
        uint256 transactionMix,
        uint256 newTransactions
    ) external {
        CreditInfo storage info = creditInfo[user];
        info.transactionVolume = transactionVolume;
        info.walletBalance = walletBalance;
        info.transactionFrequency = transactionFrequency;
        info.transactionMix = transactionMix;
        info.newTransactions = newTransactions;
        info.lastUpdated = block.timestamp;

        uint256 scaleFactor = 100;
        info.creditScore = ((info.transactionVolume * 35) +
                           (info.walletBalance * 30) +
                           (info.transactionFrequency * 15) +
                           (info.transactionMix * 10) +
                           (info.newTransactions * 10)) / scaleFactor;

        emit CheckCreditScore(user);
    }

    function getCreditScore(address user) external view returns (uint256) {
        return creditInfo[user].creditScore;
    }

    function getLastUpdated(address user) external view returns (uint256) {
        return creditInfo[user].lastUpdated;
    }
}
