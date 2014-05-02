Url      = require 'url'
settings = require '../settings'
Redis    = require 'redis'

class RedisClient
  
  constructor: ->
    @connect settings.redis_url
      
  connect: (url) ->
    
    info = Url.parse url
    
    @client = Redis.createClient(info.port, info.hostname)
    if info.auth
      @client.auth info.auth.split(":")[1]
    @client.on "error", (err) =>
      console.log "Error #{err}"
    @client.on "connect", () =>
      console.log "Successfully connected to Redis"
      
exports.RedisClient = RedisClient