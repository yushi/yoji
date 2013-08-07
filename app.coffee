express = require('express')
#routes = require('./routes')
#user = require('./routes/user')
pygments = require('./lib/pygments')
fs = require('fs')
http = require('http')
path = require('path')
pwd = process.env.PWD

app = express()

express.mime.default_type = 'text/plain'

app.set('port', process.env.PORT || 4011)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
#app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)
static_path = pwd # path.join(__dirname, 'public')
app.use(express.static(path.join(__dirname, 'public')))
app.use(require('./lib/middleware/search')(static_path))
app.use(require('./lib/middleware/directory')(static_path))
app.use(require('./lib/middleware/static')(static_path))
#app.use(express.directory(static_path))


if 'development' == app.get('env')
  app.use(express.errorHandler())


#app.get('/', routes.index)
#app.get('/users', user.list)
pygments.css (err, pygment_css)->
  if err
    console.error 'pygments error'
    process.exit(-1)
  fs.writeFileSync(__dirname + '/public/css/pygments.css', pygment_css)
  start_server()

start_server = ()->
  server = http.createServer(app)
  server.listen app.get('port'), ()->
    console.log 'Express server listening on port ' + app.get('port')
