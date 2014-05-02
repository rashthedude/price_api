(function() {
  var Express, app, info, models, rc, settings, util;

  Express = require('express');

  models = require('./models');

  settings = require('./settings');

  util = require('util');

  app = module.exports = Express();

  rc = new models.RedisClient();

  global.redisClient = rc.client;

  app.use(Express.json());

  app.use(Express.urlencoded());

  app.use(Express.methodOverride());

  app.get('/', function(req, res) {
    return res.send(200, 'Price Checking API Interface');
  });

  if (!module.parent) {
    info = app.listen(settings.application_port);
    console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env);
  }

}).call(this);
