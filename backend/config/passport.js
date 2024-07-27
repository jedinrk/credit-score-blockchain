const passport = require('passport');
const { Strategy: JwtStrategy, ExtractJwt } = require('passport-jwt');
const users = require('../models/users')


const opts = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: process.env.JWT_SECRET
};

passport.use(new JwtStrategy(opts, (jwt_payload, done) => {
  const user = users.find(u => u.id === jwt_payload.id);
  if (user) {
    return done(null, user);
  } else {
    return done(null, false);
  }
}));

module.exports = passport;
