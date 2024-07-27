const express = require('express');
const creditScoreRoutes = require('./routes/creditScoreRoutes');

const app = express();

app.use('/api', creditScoreRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
