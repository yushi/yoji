parse = require('url').parse
fs = require 'fs'
html = require '../html'
contents = require '../contents'


fs_path = (root, path)->
  return root + path


dir_table_tags = (files, root)->
  file_info = files.map (file)->
    try
      stat = fs.statSync root + file
    catch e

    {
      'is_dir': stat.isDirectory()
      'name': file
    }

  file_tags = file_info.map (f)->
    if f.is_dir
      link = html.tag 'a', f.name, {'href': "./#{f.name}/"}
    else
      link = html.tag 'a', f.name, {'href': "./#{f.name}?yoji=preview"}

    td1 = html.tag 'td', link

    raw_link = ''
    if not f.is_dir
      raw_link = html.tag 'a',
        'raw',
        {
          'class': 'btn btn-small'
          'href': "./#{f.name}"
        }

    td2 = html.tag 'td', raw_link, {'class': 'span1'}

    html.tag 'tr', td1 + td2

  table = html.tag('table',
    file_tags.join(''),
    {'class': 'table table-bordered'})

  parts = html.tag('div', table, {'class': 'span12'})
  parts = html.tag('div', table, {'class': 'container'})
  return parts

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
