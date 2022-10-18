require('dotenv').config();
const express = require('express');
const User = require('../db/schemas/userSchema');
const passport = require('passport');
const googleStrategy = require('passport-google-oauth2');
const router = express.Router();

const CLIENT_URL = 'https://www.youtube.com/';

passport.serializeUser(function (user, done) {
    done(null, user.id);
});

passport.deserializeUser(function (_id, done) {
    User.findById(_id, function (err, user) {
        done(err, user);
    });
});

passport.use(new googleStrategy({
    clientID: process.env.client_id,
    clientSecret: process.env.secret,
    callbackURL: "http://localhost:8080/google/auth/callback",
    userProfileURL: "https://www.googleapis.com/oauth2/v3/userinfo"

},
    async (accessToken, refreshToken, profile, cb) => {
        //console.log(profile);
        const [firstName, lastName] = profile.displayName.split(" ");
        User.findOrCreate({
            googleId: profile.id,
            firstName: firstName,
            lastName: lastName
        }, async(err, user) => {
                if(err){
                    console.log(err);
                }
                else if(user){
                    console.log(user);
                }
                cb(err, user);
        });
    }
));

router.get('/auth/google',
    passport.authenticate('google', { scope: ['profile', 'email'] })
);

router.get('/google/auth/callback',
    passport.authenticate('google', {
        failureRedirect: '/login',
        successRedirect: CLIENT_URL
    }),
    (req, res) => {
        //console.log(req)
    }
)


module.exports = router;