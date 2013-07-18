parse = require('url').parse
fs = require 'fs'
html = require '../html'
contents = require '../contents'


fs_path = (root, path)->
  return root + path


dir_table_tags = (files, root)->
  file_tags = files.map (file)->
    try
      stat = fs.statSync root + file
    catch e

    opt = {}
    if not stat
    else if stat.isDirectory()
      opt.href = "./#{file}/"
    else
      opt.href = "./#{file}?yoji=preview"

    html.tag 'a', file, opt

  file_tags = file_tags.map (tag)->
    td = html.tag 'td', tag
    html.tag 'tr', td

  return html.tag('table', file_tags.join(''), {'class': 'table'})


exports = module.exports = (root)->
  return DirectoryMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()

    path = fs_path root, parse(req.url).pathname
    if not fs.existsSync path
      return next()

    stat = fs.statSync path
    if not stat.isDirectory()
      return next()

    files = fs.readdirSync(path)

    head_str = html.tag 'head', contents.include_css

    body_str = html.tag 'body', [
      contents.common_parts req.path
      dir_table_tags(files, path)
      contents.include_js
    ].join ''
    html_str = html.tag 'html', head_str + body_str

    res.setHeader 'Content-Type', 'text/html'
    res.write html_str
    res.end()
