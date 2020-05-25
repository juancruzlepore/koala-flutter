var express = require('express');
var app = express();

//setting middleware
app.use(express.static(__dirname + '/build/web', { index: 'index.html' })); //Serves resources from public folder

var server = app.listen(process.env.PORT || 8080);