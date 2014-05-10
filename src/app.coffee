Express   = require 'express'
models    = require './models'
settings  = require './settings'
util      = require 'util'
app       = module.exports = Express()
rc        = new models.RedisClient()
csv       = require "csv"
fs        = require "fs"
stream    = require "stream"
request   = require "request"
notifier  = require "mail-notifier"

global.redisClient = rc.client

app.use(Express.json())
app.use(Express.urlencoded())
app.use(Express.methodOverride())

imap = {
  user: "notify@veoo.com"
  password: ""
  host: "imap.gmail.com"
  port: 993 # imap port
  box: "RATES-NOTIFY"
  tls: true #use secure connection
  tlsOptions: { rejectUnauthorized: false }
}

# Differentiate between different operators, shall it over-write or create a new file for every incoming file?
# Routes
app.get '/', (req, res) ->
  notifier(imap)
  .on 'mail',( (mail) -> 
    console.log 'here is the mail', mail.attachments
    bufferStream = new stream.Transform()
    bufferStream.push(mail.attachments[0].content)
    output = fs.createWriteStream mail.attachments[0].generatedFileName
    bufferStream.pipe(output)
  )
  .on 'error', (err) ->
    console.log 'error', err
  .on 'end', () ->
    console.log 'connection has been closed'
  .start()
    

  res.send 200, 'Price Checking API Interface'
        
    
if !module.parent
  info = app.listen(settings.application_port)
  console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env)

