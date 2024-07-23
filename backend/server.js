const app = require('./app');
const blockchainService = require('./services/blockchainService');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  blockchainService.listenToEvents(); // Start listening to blockchain events
});
