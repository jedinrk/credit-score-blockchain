const express = require('express');
const router = express.Router();
const { getCreditScore, updateTransactionVolume, updateWalletBalance, checkCreditScore } = require('../controllers/creditScoreController');

router.get('/credit-score/:user', getCreditScore);
router.post('/update-transaction-volume', updateTransactionVolume);
router.post('/update-wallet-balance', updateWalletBalance);
router.post('/check-credit-score/:user', checkCreditScore);

module.exports = router;
