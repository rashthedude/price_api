Express   = require 'express'
models    = require './models'
settings  = require './settings'
util      = require 'util'
app       = module.exports = Express()
rc        = new models.RedisClient()


global.redisClient = rc.client

app.use(Express.json())
app.use(Express.urlencoded())
app.use(Express.methodOverride())


#Routes
app.get '/', (req, res) ->
  res.send 200, 'Price Checking API Interface'
    
    
    
if !module.parent
  info = app.listen(settings.application_port)
  console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env)

