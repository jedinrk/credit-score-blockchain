const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET;

const signToken = (user) => {
  return jwt.sign({ id: user.id, username: user.username }, secretKey, { expiresIn: '1h' });
};

module.exports = {
  signToken
};
