Express   = require 'express'
models    = require './models'
settings  = require './settings'
util      = require 'util'
app       = module.exports = Express()
rc        = new models.RedisClient()
path      = require "path"
csv       = require "csv"
fs        = require "fs"
stream    = require "stream"
request   = require "request"
notifier  = require "mail-notifier"
async     = require "async"

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
# Have individual folders for different service providers?
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

# Find files in folder, determine what operator they belong to, parse to common format, insert into correct dbs
# maybe using a library like async would be ideal here
app.get '/parse', (req, res) ->
  res.send 200, 'Here is where the csv parsing gets triggered'
  p = './'
  # either search for random csv files or search for specific ones
  fs.readdir './', (err, files) ->
    if err
      throw err
    console.log 'Here are the files', files
    files.map (file) ->
      path.join p, file
    .filter (file) ->
      fs.statSync(file).isFile()
    .forEach (file) ->
      console.log "%s (%s)", file, path.extname(file) 
      if path.extname(file)  == '.csv'
        console.log 'here is the found csv', file
        # this is where the csv module comes in!
        csv()
        .from.path('./' + file)
        .to.stream(fs.createWriteStream(__dirname + '/sample.out'))
        .transform( (row) ->
          row.unshift(row.pop())
          return row 
        )
        .on 'record', (row, index) ->
          console.log '#' + index + ' ' + JSON.stringify(row)
        .on 'error', (err) ->
          console.log 'Error: ', err


        
    
if !module.parent
  info = app.listen(settings.application_port)
  console.log("Express server listening on connection %s, environment %s", info['_connectionKey'], app.settings.env)

