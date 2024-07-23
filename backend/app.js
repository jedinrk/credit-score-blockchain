const express = require('express');
const bodyParser = require('body-parser');
const creditScoreRoutes = require('./routes/creditScoreRoutes');

const app = express();
app.use(bodyParser.json());

app.use('/api/creditscore', creditScoreRoutes);

module.exports = app;
