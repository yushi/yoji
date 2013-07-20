contents = require '../contents'
html = require '../html'
ag = require '../ag'


get_highlighted_code = (str, highlights)->
  console.log '"' + str + '"', highlights
  parts = []
  idx = 0
  for h in highlights
    parts.push [str[idx..(h[0]-1)], 0]
    parts.push [str[h[0]..(h[0]+h[1]-1)], 1]
    idx = h[0] + h[1] - 1
  parts.push [str[idx+1..], 0]
  console.log parts
  parts = parts.map (p)->
    if p[1] == 1
      html.tag 'span', html.escape(p[0]), {'class': 'highlight'}
    else
      html.escape(p[0])
  parts.join('')


get_table_entries = (path, lines)->
  tags = ''
  for num, line_info of lines
    line = line_info[0]
    highlights = line_info[1]

    line = get_highlighted_code line, highlights
    tags += html.tag 'tr', [
      html.tag 'td', path, {'rowspan': Object.keys(lines).length} if tags == ''
      html.tag 'td', html.tag('a', num, {'href': "#{path}?yoji=preview"})
      html.tag 'td', html.tag('code', line)
    ].join('')

  tags

exports = module.exports = (root)->
  return SearchMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()
    if not req.query.kw
      return next()

    keyword = req.query.kw
    ag.ag keyword, root + req.path, (entries)->
      results = []
      for k, v of entries
        k = k.replace(root, '')
        results.push(get_table_entries k, v)

      results = html.tag 'table', results.join(''),
        {'class': 'table table-hover'}
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
