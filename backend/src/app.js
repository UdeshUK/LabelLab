const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const fileUpload = require('express-fileupload');
const mongoose = require('mongoose');
require('dotenv').config();

const config = require('../app.config')
const indexRouter = require('./api/index');
const classifyRouter = require('./api/classify');
const authRouter = require('./auth/auth');

var app = express();

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(fileUpload());

mongoose.Promise = global.Promise;

mongoose.connect(config.DB, { useNewUrlParser: true })
  .then(() => {
    console.log("Successfully connected to MongoDB.");
  }).catch(err => {
    console.log('Could not connect to MongoDB.');
    console.log(err);
    process.exit();
  });

app.use(config.VERSION, indexRouter);
app.use(config.VERSION + '/auth', authRouter);
app.use(config.VERSION + '/classify', classifyRouter);

app.set('port', process.env.PORT || 3000);
module.exports = app;
