var express = require('express');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var fileUpload = require('express-fileupload');

var config = require('./app.config')
var indexRouter = require('./routes/index');
var classifyRouter = require('./routes/classify');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(fileUpload());

app.use('/', indexRouter);
app.use('/classify', classifyRouter);

app.set('port', process.env.PORT || 3000);
module.exports = app;
