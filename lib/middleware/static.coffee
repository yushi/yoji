parse = require('url').parse
fs = require 'fs'
html = require '../html'
contents = require '../contents'
express = require 'express'

fs_path = (root, path)->
  return root + path


lookup_type = (path)->
  return 'html' if path.match /\.(:?html|htm)$/
  return 'css' if path.match /\.css$/
  return 'png' if path.match /\.png$/
  return 'markdown' if path.match /\.(:?markdown|md)$/
  return 'javascript' if path.match /\.js$/
  return


raw_contents = (res, type, data)->
  res.setHeader 'Content-Type', type
  res.write data
  res.end()


exports = module.exports = (root)->
  return StaticMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()

    if req.query.yoji != 'preview'
      static_middleware = express.static(root)
      static_middleware(req, res, next)
      return

    path = fs_path root, parse(req.url).pathname
    if not fs.existsSync path
      return next()

    stat = fs.statSync path
    if stat.isDirectory()
      return next()

    data = fs.readFileSync(path)
    switch lookup_type path
      when 'markdown'
        showdown = require 'showdown'
        conv = new showdown.converter()
        data = conv.makeHtml data.toString()
      when 'javascript'
        data = html.escape data
        data = html.tag 'code', data.toString(), {'data-language': 'javascript'}
        data = html.tag 'pre', data
      else
        data = html.tag 'pre', html.escape(data)

    head = html.tag 'head', contents.include_css

    title = html.tag 'h1', req.url
    hr = html.tag 'hr'

    body = html.tag 'body', [
      contents.breadcrumb req.path
      contents.navbar
      hr
      data
      contents.include_js
    ].join ''
    html_str = html.tag 'html', head + body
    res.setHeader 'Content-Type', 'text/html'
    res.write html_str
    res.end()
