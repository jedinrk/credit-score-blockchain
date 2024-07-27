const contract = require('../services/creditScoreService');

const getCreditScore = async (req, res) => {
  try {
    const { user } = req.params;
    const creditScore = await contract.getCreditScore(user);
    res.json({ creditScore: creditScore.toString() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateTransactionVolume = async (req, res) => {
  try {
    const { user } = req.body;
    const { volume } = req.body;
    const tx = await contract.updateTransactionVolume(user, volume);
    await tx.wait();
    res.json({ message: 'Transaction volume updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateWalletBalance = async (req, res) => {
  try {
    const { user } = req.body;
    const { balance } = req.body;
    const tx = await contract.updateWalletBalance(user, balance);
    await tx.wait();
    res.json({ message: 'Wallet balance updated' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const checkCreditScore = async (req, res) => {
  try {
    const { user } = req.params;
    const tx = await contract.checkCreditScore(user);
    await tx.wait();
    res.json({ message: 'Credit score checked' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getCreditScore,
  updateTransactionVolume,
  updateWalletBalance,
  checkCreditScore,
};