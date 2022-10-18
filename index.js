const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const session = require('express-session');
const cors = require('cors');
const PORT = 8080;
const tender = require('./routes/tender');
const auth = require('./routes/auth');
require('./db/connection');
app.use(cors);
app.use(express.json());
app.use(bodyParser.json())
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.urlencoded({extended : true}));

app.use(session({
    secret : 'some very long string',
    resave : false,
    saveUninitialized : false,
    cookie : {
        maxAge : 1 * 24 * 60 * 60 * 1000
    }
}));

app.use('/tender', tender);
app.use(auth);

app.listen(PORT, ()=>{
    console.log('server started at port 8080');
})