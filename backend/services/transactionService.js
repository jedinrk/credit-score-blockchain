const { Web3, HttpProvider } = require('web3');

const { INFURA_URL } = process.env;

const web3 = new Web3(new HttpProvider(INFURA_URL));

/**
 * Fetch the transactions of a given address from a last six months(approx or assumption based) 
 * Filter transactions based on Eth transfer, DEX and DEFI protocol interactions.
 * 
 * TODO Add Defi protocol method references. 
 * 
 */
exports.fetchTransactions = async (address) => {
  const latestBlock = await web3.eth.getBlockNumber();
  const blocksInSixMonths = Math.floor(180 * 24 * 60 * 60 / 13);
  const startBlock = latestBlock - blocksInSixMonths;

  const logs = await web3.eth.getPastLogs({
    address: address,
    fromBlock: startBlock,
    toBlock: 'latest'
  });

  const transactions = logs.map(log => log.transactionHash);
  const uniqueTransactions = [...new Set(transactions)];

  const transactionDetails = await Promise.all(uniqueTransactions.map(txHash => web3.eth.getTransaction(txHash)));

  console.log('Transaction Details:', transactionDetails);

  // Filter transactions (e.g., ETH transfers, DEX transactions, etc.)
  const ethTransfers = transactionDetails.filter(tx => tx.value > 0);
  //TODO
  const dexTransactions = transactionDetails.filter(tx =>{ /* logic to identify DEX transactions */});
  const defiTransactions = transactionDetails.filter(tx => {/* logic to identify DeFi transactions */});

  console.log('ETH Transfers:', ethTransfers);
  console.log('DEX Transactions:', dexTransactions);
  console.log('DeFi Transactions:', defiTransactions);

};
