const blockchainService = require('../services/blockchainService');

exports.getCreditScore = async (req, res) => {
  try {
    const { address } = req.params;
    const creditScore = await blockchainService.getCreditScore(address);
    res.json({ address, creditScore });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
