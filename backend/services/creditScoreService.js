const { Web3, HttpProvider } = require('web3');
const config = require('../config/config');

const web3 = new Web3(new HttpProvider(config.infuraUrl));
const contract = new web3.eth.Contract(config.contractABI.abi, config.contractAddress);

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
