const { ethers } = require('ethers');
const config = require('../config/config');

const provider = new ethers.providers.JsonRpcProvider(config.infuraUrl);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contract = new ethers.Contract(config.contractAddress, config.contractABI, wallet);

module.exports = contract;
