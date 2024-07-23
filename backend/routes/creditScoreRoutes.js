const express = require('express');
const router = express.Router();
const creditScoreController = require('../controllers/creditScoreController');

router.get('/:address', creditScoreController.getCreditScore);

module.exports = router;
