const { ethers } = require('ethers');
const config = require('../config/config');

const provider = new ethers.providers.JsonRpcProvider(config.infuraUrl);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contract = new ethers.Contract(config.contractAddress, config.contractABI, wallet);

//Event listener service for smart contract
/*exports.listenToEvents = () => {
  creditScoreContract.events.CheckCreditScore()
    .on('data', async (event) => {
      const userAddress = event.returnValues.user;
      console.log(`Received CheckCreditScore event for address: ${userAddress}`);
      await transactionService.fetchTransactions(userAddress);
    })
};*/

module.exports = contract;
