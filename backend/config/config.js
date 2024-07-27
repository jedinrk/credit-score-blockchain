require('dotenv').config();

module.exports = {
  infuraUrl: process.env.INFURA_URL,
  contractAddress: process.env.CONTRACT_ADDRESS,
  contractABI: require('../abis/CreditScore.json')
};