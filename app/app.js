(function() {
  var Express, MailListener, Mailparser, app, csv, fs, imap, info, models, notifier, rc, request, settings, stream, util;

  Express = require('express');

  models = require('./models');

  settings = require('./settings');

  util = require('util');

  app = module.exports = Express();

  rc = new models.RedisClient();

  MailListener = require("mail-listener2");

  csv = require("csv");

  fs = require("fs");

  stream = require("stream");

  request = require("request");

  Mailparser = require("mailparser").MailParser;

  notifier = require("mail-notifier");

  global.redisClient = rc.client;

  app.use(Express.json());

  app.use(Express.urlencoded());

  app.use(Express.methodOverride());

  imap = {
    user: "notify@veoo.com",
    password: "",
    host: "imap.gmail.com",
    port: 993,
    box: "RATES-NOTIFY",
    tls: true,
    tlsOptions: {
      rejectUnauthorized: false
    }
  };

  notifier(imap).on('mail', (function(mail) {
    var bufferStream, output;
    console.log('here is the mail', mail.attachments);
    bufferStream = new stream.Transform();
    bufferStream.push(mail.attachments[0].content);
    output = fs.createWriteStream(mail.attachments[0].generatedFileName);
    return bufferStream.pipe(output);
  })).on('error', function(err) {
    return console.log('error', err);
  }).on('end', function() {
    return console.log('connection has been closed');
  }).start();

  app.get('/', function(req, res) {
    return res.send(200, 'Price Checking API Interface');
  });

  if (!module.parent) {
    info = app.listen(settings.application_port);
    console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env);
  }

}).call(this);
