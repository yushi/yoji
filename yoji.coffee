#!/usr/bin/env coffee
connect = require('connect')
path = process.env.PWD
app = connect()
app.use(connect.logger())
app.use(connect.static(path))
app.use(connect.directory(path))
app.listen(5000)
