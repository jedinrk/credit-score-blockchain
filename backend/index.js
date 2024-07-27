require('dotenv').config()

const express = require('express');
const passport = require('./config/passport');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { signToken } = require('./utils/jwt');
const creditScoreRoutes = require('./routes/creditScoreRoutes');
const users = require('./models/users')

const app = express();
app.use(express.json());
app.use(passport.initialize());


/**
 * Login API
 */
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username);
  if (!user) {
    return res.status(401).json({ message: 'Incorrect username or password' });
  }
  bcrypt.compare(password, user.password, (err, isMatch) => {
    if (err) throw err;
    if (isMatch) {
      const token = signToken(user);
      res.json({ message: 'Logged in successfully', token });
    } else {
      res.status(401).json({ message: 'Incorrect username or password' });
    }
  });
});

const isAuthenticated = passport.authenticate('jwt', { session: false });

app.use('/api', isAuthenticated, creditScoreRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
