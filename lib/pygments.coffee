spawn = require('child_process').spawn

css = (cb)->
  p = spawn('pygmentize', ['-S', 'default', '-f', 'html'])
  css = ''
  p.stdout.on 'data', (chunk)->
    css += chunk.toString()

  p.on 'close', (code, signal)->
    err = false
    if code != 0
      err = true

    cb(err, css)


highlight = (path, cb)->
  p = spawn('pygmentize',
    [
      '-f', 'html'
      '-O', 'encoding=utf-8'
      '-O', 'outencoding=utf-8'
      path
    ])
  html = ''
  p.stdout.on 'data', (chunk)->
    html += chunk

  p.on 'close', (code, signal)->
    err = false
    if code != 0
      err = true

    cb(err, html)

exports.css = css
exports.highlight = highlight
