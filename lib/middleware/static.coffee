parse = require('url').parse
fs = require 'fs'
html = require '../html'
contents = require '../contents'

fs_path = (root, path)->
  return root + path


lookup_type = (path)->
  return 'markdown' if path.match /\.(:?markdown|md)$/
  return 'javascript' if path.match /\.js$/
  return


exports = module.exports = (root)->
  return StaticMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()

    path = fs_path root, parse(req.url).pathname
    if not fs.existsSync path
      return next()

    stat = fs.statSync path
    if stat.isDirectory()
      return next()

    data = html.escape fs.readFileSync(path).toString()
    switch lookup_type path
      when 'markdown'
        showdown = require 'showdown'
        conv = new showdown.converter()
        data = conv.makeHtml data
      when 'javascript'
        data = html.tag 'code', data, {'data-language': 'javascript'}
        data = html.tag 'pre', data
      else
        data = html.tag 'pre', data

    head = html.tag 'head', contents.include_css

    title = html.tag 'h1', req.url
    hr = html.tag 'hr'

    body = html.tag 'body', [
      contents.breadcrumb req.url
      contents.navbar
      hr
      data
      contents.include_js
    ].join ''
    html_str = html.tag 'html', head + body
    res.setHeader 'Content-Type', 'text/html'
    res.write html_str
    res.end()
