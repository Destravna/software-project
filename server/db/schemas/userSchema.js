const mongoose = require('mongoose');
const findOrCreate = require('mongoose-findorcreate');

const userSchema = new mongoose.Schema({
    'googleId': {
        type: String,
        require: true,
        unique: true
    },
    'email': {
        type: String,
        require: true,
        unique : false
    },
    'firstName': {
        type: String
    },
    'lastName': {
        type: String
    },
    'dob': {
        type: Date
    },
    'phone': {
        type: Number
    },
    'skills': [{
        type : String
    }],
    'experience': {
        type: Number
    }
});

userSchema.plugin(findOrCreate);

const user = mongoose.model('user', userSchema);

module.exports = user;

