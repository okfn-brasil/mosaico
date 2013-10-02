'use strict';

var express = require('express');
var app = express();
var port = process.env.PORT || 3000;

app.configure(function () {
  app.use(express.compress());
  app.use(express.static(__dirname + '/dist'));
  app.use(app.router);
});

app.get('*', function (req, res) {
  res.sendfile('dist/index.html');
});

app.listen(port, function () {
  console.log("Listening on " + port);
});
