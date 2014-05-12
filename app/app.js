(function() {
  var Express, app, async, csv, fs, imap, info, models, notifier, path, rc, request, settings, stream, util;

  Express = require('express');

  models = require('./models');

  settings = require('./settings');

  util = require('util');

  app = module.exports = Express();

  rc = new models.RedisClient();

  path = require("path");

  csv = require("csv");

  fs = require("fs");

  stream = require("stream");

  request = require("request");

  notifier = require("mail-notifier");

  async = require("async");

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

  app.get('/', function(req, res) {
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
    return res.send(200, 'Price Checking API Interface');
  });

  app.get('/parse', function(req, res) {
    var p;
    res.send(200, 'Here is where the csv parsing gets triggered');
    p = './';
    return fs.readdir('./', function(err, files) {
      if (err) {
        throw err;
      }
      console.log('Here are the files', files);
      return files.map(function(file) {
        return path.join(p, file);
      }).filter(function(file) {
        return fs.statSync(file).isFile();
      }).forEach(function(file) {
        console.log("%s (%s)", file, path.extname(file));
        if (path.extname(file) === '.csv') {
          console.log('here is the found csv', file);
          return csv().from.path('./' + file).to.stream(fs.createWriteStream(__dirname + '/sample.out')).transform(function(row) {
            row.unshift(row.pop());
            return row;
          }).on('record', function(row, index) {
            return console.log('#' + index + ' ' + JSON.stringify(row));
          }).on('error', function(err) {
            return console.log('Error: ', err);
          });
        }
      });
    });
  });

  if (!module.parent) {
    info = app.listen(settings.application_port);
    console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env);
  }

}).call(this);
