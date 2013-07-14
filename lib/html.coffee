tag = (tag_name, data, opt)->
  attr = ''
  for key, val of opt
    attr += " #{key}=\"#{val}\""

  return ['<', tag_name, attr, '>', data, '</', tag_name, '>'].join('')


css_tag = (href)->
  return tag 'link', '',
    'href': href
    'rel':'stylesheet'
    'type':'text/css'


js_tag = (src)->
  return tag 'script', '',
    'type': 'text/javascript'
    'src': src


escape = (html)->
  return String(html)
    .replace(/&(?!\w+;)/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')

exports.tag = tag
exports.css_tag = css_tag
exports.js_tag = js_tag
exports.escape = escape
