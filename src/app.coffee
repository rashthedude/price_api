Express   = require 'express'
models    = require './models'
settings  = require './settings'
util      = require 'util'
app       = module.exports = Express()


app.use(Express.json())
app.use(Express.urlencoded())
app.use(Express.methodOverride())



app.get '/', (req, res) ->
  res.send 200, 'Price Checking API Interface'
    
    
    
if !module.parent
  info = app.listen(settings.application_port)
  console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env)

