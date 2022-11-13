const mongoose = require('mongoose');
const findOrCreate = require('mongoose-findorcreate');

const tenderSchema = new mongoose.Schema({
    'title': {
        type: String
    },
    'description': {
        type: String
    },
    'skills': [{
        type: String
    }],
    'budget': {
        type: Number
    },
    'experience' : {
        type: Number
    },
    'dueDate': {
        type: Date
    },
    'user': {
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'User' //foreign key from the user
    },
    'applications':[{
        type: mongoose.SchemaTypes.ObjectId,
        ref: 'User'
    }]
});

const tender = mongoose.model('tender', tenderSchema);
module.exports = tender;