var express = require('express');
var cors = require('cors');
var app = express();

//setting middleware
app.use(express.static(__dirname + '/build/web', {
    index: 'index.html',
})); //Serves resources from public folder

//app.use(function(req, res, next) {
//  res.header("Access-Control-Allow-Origin", "herokuapp.com"); // update to match the domain you will make the request from
//  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//  next();
//});

app.use(cors);

var server = app.listen(process.env.PORT || 9090);