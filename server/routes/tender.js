const Tender = require('../db/schemas/tenderSchema');
const express = require('express'); 
const router = express.Router();

//adding a new tender 
router.post('/addTender', async(req, res)=>{
    if(req.isAuthenticated()){
        try{
            const data = Tender.create(
                {
                    ...req.body, 
                    user:req.session.passport.user
                }
            );
        }
        catch(err){
            console.log(err);
            res.status(500).json({'msg':'internal server error'})
        }

    }
    else{
        res.status(401).json({msg: 'unauthorized'});
    }
});

router.patch('/apply/:tenderId', async(req, res)=>{
    if(req.isAuthenticated()){
        const data = await Tender.findByIdAndUpdate(req.params.tenderId, {
            $push: {
                applications : req.session.passport.user
            }
        });
    }
    else{
        res.status(401).json({msg: 'unauthorized'});
    }
})

module.exports = router;

