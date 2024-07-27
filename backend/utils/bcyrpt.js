require('dotenv').config()

const bcrypt = require('bcryptjs');
const saltRounds = 10;
const password = process.env.ADMIN_SECRET;

bcrypt.hash(password, saltRounds, (err, hash) => {
  if (err) throw err;
  console.log(hash); // Hash to be used for storing users password in passport.js
});