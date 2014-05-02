(function() {
  var Redis, RedisClient, Url, settings;

  Url = require('url');

  settings = require('../settings');

  Redis = require('redis');

  RedisClient = (function() {
    function RedisClient() {
      this.connect(settings.redis_url);
    }

    RedisClient.prototype.connect = function(url) {
      var info;
      info = Url.parse(url);
      this.client = Redis.createClient(info.port, info.hostname);
      if (info.auth) {
        this.client.auth(info.auth.split(":")[1]);
      }
      this.client.on("error", (function(_this) {
        return function(err) {
          return console.log("Error " + err);
        };
      })(this));
      return this.client.on("connect", (function(_this) {
        return function() {
          return console.log("Successfully connected to Redis");
        };
      })(this));
    };

    return RedisClient;

  })();

  exports.RedisClient = RedisClient;

}).call(this);
