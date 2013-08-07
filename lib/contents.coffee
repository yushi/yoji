html = require './html'


rpath = (path, basepath)->
  "#{basepath}#{path}"

navbar_tags = (basepath)->
  #lis = [].map (e)->
  #  a = html.tag 'a', e, {'href': '#'}
  #  html.tag 'li', a

  nav = html.tag 'a', 'Yoji', {'class': 'brand', 'href': rpath('/', basepath)}
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


css_tags = (basepath)->
  css_files = [
    rpath('/css/style.css', basepath)
    rpath('/css/pygments.css', basepath)
    rpath('/css/bootstrap.min.css', basepath)
  ]
  tags = css_files.map (path)->
    return html.css_tag path

  return tags.join ''


js_tags = (basepath)->
  js_files = [
    rpath('/js/jquery-2.0.2.min.js', basepath)
    rpath('/js/yoji.js', basepath)
  ]
  tags = js_files.map (path)->
    return html.js_tag path

  return tags.join ''


breadcrumb = (path, basepath)->
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
        html.tag 'a', name, {'href':rpath('/', basepath)}
        slash
      ].join ''
    else
      lis.push html.tag 'li', [
        html.tag 'a', name,
          {'href':rpath("/#{names[1..i].join('/')}/", basepath)}
        slash
      ].join ''

  if is_dir
    lis.push html.tag 'li', last + slash
  else
    lis.push html.tag 'li', last

  return html.tag 'ul', lis.join(''), {'class': 'breadcrumb'}


common_parts = (path, basepath)->
  navbar_tags(basepath) + breadcrumb(path, basepath)

exports.include_js = js_tags
exports.include_css = css_tags
exports.common_parts = common_parts
