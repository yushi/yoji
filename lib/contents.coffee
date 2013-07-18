html = require './html'


navbar_tags = ()->
  #lis = [].map (e)->
  #  a = html.tag 'a', e, {'href': '#'}
  #  html.tag 'li', a

  nav = html.tag 'a', 'Yoji', {'class': 'brand', 'href': '/'}
  nav_input = html.tag 'input',
    '',
    {
      'class': 'search-query span2'
      'type': 'text'
      'placeholder': 'keyword'
      'name': 'kw'
    }
  nav += html.tag 'form',
    nav_input,
    {
      'class': 'navbar-search pull-right'
    }
  #nav += html.tag 'ul', lis.join(''), {'class': 'nav'}
  navbar_inner = html.tag 'div', nav, {'class': 'navbar-inner'}
  navbar = html.tag 'div', navbar_inner, {'class': 'navbar navbar-static-top'}
  return navbar


css_tags = ()->
  css_files = [
    '/css/style.css'
    '/css/rainbow_github.css'
    '/css/bootstrap.min.css'
  ]
  tags = css_files.map (path)->
    return html.css_tag path

  return tags.join ''


js_tags = ()->
  js_files = [
    '/js/rainbow-custom.min.js'
    '/js/jquery-2.0.2.min.js'
  ]
  tags = js_files.map (path)->
    return html.js_tag path

  return tags.join ''


breadcrumb = (path)->
  path = 'root' + path
  is_dir = false
  is_dir = true if path.match(/\/$/)
  path = path.replace(/\/$/, '')

  slash = html.tag 'span', '/', {'class': 'divider'}

  names = path.split('/')
  last = names.pop()

  lis = []
  for name, i in names
    if i == 0
      lis.push html.tag 'li', [
        html.tag 'a', name, {'href':'/'}
        slash
      ].join ''
    else
      lis.push html.tag 'li', [
        html.tag 'a', name, {'href':"/#{names[1..i].join('/')}/"}
        slash
      ].join ''

  if is_dir
    lis.push html.tag 'li', last + slash
  else
    lis.push html.tag 'li', last

  return html.tag 'ul', lis.join(''), {'class': 'breadcrumb'}


common_parts = (path)->
  navbar_tags() + breadcrumb(path)

exports.include_js = js_tags()
exports.include_css = css_tags()
exports.common_parts = common_parts
