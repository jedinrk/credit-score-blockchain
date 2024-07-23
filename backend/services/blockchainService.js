const Web3 = require('web3');
const CreditScore = require('../build/contracts/CreditScore.json');
const { INFURA_URL, CONTRACT_ADDRESS } = process.env;
const transactionService = require('./transactionService');

const web3 = new Web3(new Web3.providers.HttpProvider(INFURA_URL));

const creditScoreContract = new web3.eth.Contract(CreditScore.abi, CONTRACT_ADDRESS);

exports.getCreditScore = async (address) => {
  return await creditScoreContract.methods.getCreditScore(address).call();
};

exports.listenToEvents = () => {
  creditScoreContract.events.CheckCreditScore()
    .on('data', async (event) => {
      const userAddress = event.returnValues.user;
      console.log(`Received CheckCreditScore event for address: ${userAddress}`);
      await transactionService.fetchTransactions(userAddress);
    })
    .on('error', console.error);
};
