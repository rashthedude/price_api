(function() {
  var Express, MailListener, Mailparser, app, csv, fs, info, mailListener, models, mp, rc, request, settings, util;

  Express = require('express');

  models = require('./models');

  settings = require('./settings');

  util = require('util');

  app = module.exports = Express();

  rc = new models.RedisClient();

  MailListener = require("mail-listener2");

  csv = require("csv");

  fs = require("fs");

  request = require("request");

  Mailparser = require("mailparser").MailParser;

  mp = new Mailparser({
    streamAttachments: true
  });

  global.redisClient = rc.client;

  app.use(Express.json());

  app.use(Express.urlencoded());

  app.use(Express.methodOverride());

  mailListener = new MailListener({
    username: "notify@veoo.com",
    password: "bOC8yh32phf",
    host: "imap.gmail.com",
    port: 993,
    tls: true,
    tlsOptions: {
      rejectUnauthorized: false
    },
    mailbox: "RATES-NOTIFY",
    markSeen: true,
    fetchUnreadOnStart: true,
    mailParserOptions: {
      streamAttachments: true
    }
  });

  app.get('/', function(req, res) {
    mailListener.start();
    mailListener.on("server:connected", function() {
      return console.log("Successfully connected to the Notify Imap server");
    });
    mailListener.on("mail", function(mail, seqno, attributes) {
      return mp.on("attachment", function(attachment) {
        var output;
        console.log('we are here');
        output = fs.createWriteStream(attachment.generatedFileName);
        return attachment.pipe(output);
      });
    });
    return res.send(200, 'Price Checking API Interface');
  });

  if (!module.parent) {
    info = app.listen(settings.application_port);
    console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env);
  }

}).call(this);
