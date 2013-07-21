parse = require('url').parse
fs = require 'fs'
html = require '../html'
contents = require '../contents'
express = require 'express'
rst = require('../rst')
pygments = require('../pygments')

fs_path = (root, path)->
  return root + path


lookup_type = (path)->
  return 'html' if path.match /\.(:?html|htm)$/
  return 'css' if path.match /\.css$/
  return 'png' if path.match /\.png$/
  return 'markdown' if path.match /\.(:?markdown|md)$/
  return 'rst' if path.match /\.rst$/
  return 'javascript' if path.match /\.js$/
  return 'python' if path.match /\.py$/
  return


raw_contents = (res, type, data)->
  res.setHeader 'Content-Type', type
  res.write data
  res.end()


deco_code = (code)->
  max_line = code.split('\n').length
  linum_divs = []
  for i in [1..max_line]
    linum_divs.push html.tag('span', i, {'class': 'linum'})

  line = html.tag 'td', linum_divs.join('')
  code = html.tag 'td', code, {'class': 'code'}
  tags = html.tag 'tr', line + code
  tags = html.tag 'tbody', tags
  tags = html.tag 'table', tags, {'class': 'table table-hover'}
  tags = html.tag 'div', tags, {'class': 'span12'}
  tags = html.tag 'div', tags, {'class': 'container'}
  tags

deco_contents = (req, res, data)->
  data = html.tag 'div', data, {'class': 'span12'}
  data = html.tag 'div', data, {'class': 'container'}

  head = html.tag 'head', contents.include_css

  title = html.tag 'h1', req.url
  hr = html.tag 'hr'

  body = html.tag 'body', [
    contents.common_parts req.path
    data
    contents.include_js
  ].join ''
  html_str = html.tag 'html', head + body
  res.setHeader 'Content-Type', 'text/html'
  res.write html_str
  res.end()


exports = module.exports = (root)->
  return StaticMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()

    if req.query.yoji != 'preview'
      static_middleware = express.static(root, {hidden: true})
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
      when 'rst'
        rst.rst_to_html data, (html_data)->
          deco_contents(req, res, html_data)
        return
      else
        pygments.highlight path, (err, highlighted)->
          if err
            highlighted = html.tag 'pre', data
          deco_contents(req, res, deco_code(highlighted))
        return

    deco_contents(req, res, data)
