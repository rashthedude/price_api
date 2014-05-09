Express   = require 'express'
models    = require './models'
settings  = require './settings'
util      = require 'util'
app       = module.exports = Express()
rc        = new models.RedisClient()
MailListener = require "mail-listener2"
csv       = require "csv"
fs        = require "fs"
request   = require "request"
Mailparser = require("mailparser").MailParser
notifier  = require "mail-notifier"

mp = new Mailparser({streamAttachments: true})

global.redisClient = rc.client

app.use(Express.json())
app.use(Express.urlencoded())
app.use(Express.methodOverride())

imap = {
  user: "notify@veoo.com"
  password: "bOC8yh32phf"
  host: "imap.gmail.com"
  port: 993 # imap port
  box: "RATES-NOTIFY"
  tls: true #use secure connection
  tlsOptions: { rejectUnauthorized: false }
}
notifier(imap).on 'mail',(mail) -> 
  console.log 'here is the mail'
  start()


# mailListener = new MailListener
#   username: "notify@veoo.com"
#   password: "bOC8yh32phf"
#   host: "imap.gmail.com"
#   port: 993 # imap port
#   tls: true
#   tlsOptions: { rejectUnauthorized: false }
#   mailbox: "RATES-NOTIFY" # mailbox to monitor
#   markSeen: true # all fetched email willbe marked as seen and not fetched next time
#   fetchUnreadOnStart: true
#   mailParserOptions: {streamAttachments: true} # makes it able to read email attachments

#Routes
app.get '/', (req, res) ->    
    
  # mailListener.start()
  # mailListener.on "server:connected", ->
  #   console.log "Successfully connected to the Notify Imap server"
    
  # mailListener
  #   .on "mail", (mail, seqno, attributes) ->
  #     mp.on "attachment", (attachment) ->
  #       console.log 'we are here'
  #       output = fs.createWriteStream(attachment.generatedFileName)
  #       attachment.pipe(output)
  
  #mailListener
  #.on "mail", (mail, seqno, attributes) ->
    # read attachment here using csv() 
    #console.log "Parsed email here: ", mail.attachments
    #output = fs.createWriteStream('mail.attachments.generateFileName')
    #output = fs.createReadStream(mail)
    #output.on "data", (data) ->
    #  console.log 'data here', data
    #mail.stream.pipe(output)
  #.on "attachment", (att) ->
   # console.log 'we are here now', att
    #csv()
    #.from(mail.attachments)
    #.on 'record', (row, index) ->
    #  console.log 'stuff', row: index
    #.on 'close', (count) ->
    #  console.log 'count', count
    #.on 'error', (err) ->
    #  console.log 'error msg', err.message
    #.on 'end', (result) ->
    #  console.log 'results', result
          
  
  res.send 200, 'Price Checking API Interface'
    
    
    
if !module.parent
  info = app.listen(settings.application_port)
  console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env)

