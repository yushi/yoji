spawn = require('child_process').spawn

css = (cb)->
  p = spawn('pygmentize', ['-S', 'default', '-f', 'html'])
  css = ''
  p.stdout.on 'data', (chunk)->
    css += chunk.toString()

  p.on 'close', (code, signal)->
    console.log code, signal
    cb(css)

highlight = (path, cb)->
  p = spawn('pygmentize', ['-f', 'html', path])
  html = ''
  p.stdout.on 'data', (chunk)->
    html += chunk

  p.on 'close', (code, signal)->
    console.log code, signal
    console.log html
    cb(html)

exports.css = css
exports.highlight = highlight
