(function() {
  var Express, MailListener, Mailparser, app, csv, fs, imap, info, models, mp, notifier, rc, request, settings, util;

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

  notifier = require("mail-notifier");

  mp = new Mailparser({
    streamAttachments: true
  });

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

  notifier(imap).on('mail', function(mail) {
    console.log('here is the mail');
    return start();
  });

  app.get('/', function(req, res) {
    return res.send(200, 'Price Checking API Interface');
  });

  if (!module.parent) {
    info = app.listen(settings.application_port);
    console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env);
  }

}).call(this);
