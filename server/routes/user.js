const express = require('express');
const User = require('../db/schemas/userSchema');
const router = express.Router();

router.patch('/update', async (req, res) => {
    if (req.isAuthenticated()) {
        try {
            const data = await User.findByIdAndUpdate(
                req.session.passport.user,
                req.body,
                { new: true }
            );
            res.status(200).json({ 'msg': 'ok', 'data': data });
        }
        catch (err) {
            res.status(500);
        }
    }
    else {
        res.status(401).json({msg: 'unauthorized'});
    }
});