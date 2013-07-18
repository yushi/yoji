contents = require '../contents'
html = require '../html'
ag = require '../ag'


exports = module.exports = (root)->
  return SearchMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()
    if not req.query.kw
      return next()

    keyword = req.query.kw
    ag.ag keyword, root + req.path, (entries)->
      results = entries.map (entry)->
        path = entry[0].replace(root, '')
        line = html.escape entry[1]
        link = html.tag 'a', path, {'href': "#{path}?yoji=preview"}
        link = html.tag 'td', link

        hit = html.tag 'code', line
        hit = html.tag 'td', hit

        html.tag 'tr', link + hit

      results = html.tag 'table', results.join(''),
        {'class': 'table table-hovere'}
      results = html.tag 'div', results, {'class': 'span12'}
      results = html.tag 'div', results, {'class': 'container'}
      head_str = html.tag 'head', contents.include_css
      body_str = html.tag 'body', [
        contents.common_parts req.path
        results
        contents.include_js
      ].join ''
      html_str = html.tag 'html', head_str + body_str

      res.setHeader 'Content-Type', 'text/html'
      res.write html_str
      res.end()
