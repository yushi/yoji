spawn = require('child_process').spawn

rst_to_html = (rst, cb)->
  rst2html_py = spawn('rst2html.py')
  html = ''
  rst2html_py.stdout.on 'data', (chunk)->
    html += chunk.toString()
  rst2html_py.on 'close', (code, signal)->
    console.log code, signal
    cb(html)

  rst2html_py.stdin.write(rst)
  rst2html_py.stdin.end()

exports.rst_to_html = rst_to_html
