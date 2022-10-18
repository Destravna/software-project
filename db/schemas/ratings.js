const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
    ratedBy: {
        type: mongoose.Types.ObjectId,
        ref: 'user'
    },
    ratedTo: {
        type: mongoose.Types.ObjectId,
        ref: 'user'
    },
    value :  {
        type : Number,
        require : true
    }
});

const rating = mongoose.model('rating', ratingSchema);
module.exports = rating;