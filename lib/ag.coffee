spawn = require('child_process').spawn


parse_result = (path, lines)->
  lines = lines.split('\n')
  lines = lines.filter (line)->
    line != ''

  entries = {}
  filename = ''
  for line in lines
    if line[0] == ':'
      filename = line[1..]
    else
      matched = line.match(/^(\d+?);(.+?):(.*)$/)
      linum = matched[1]
      highlight = matched[2].split(',')
      highlight = highlight.map (h)->
        h.split(' ').map (e)->
          parseInt e
      str = matched[3]
      entries[filename] = {} if not entries[filename]
      entries[filename][linum] = [str, highlight]

  return entries

ag = (pattern, path, cb)->
  ag_cmd = spawn('ag', [pattern, path, '--ackmate'])

  result = ''
  ag_cmd.stdout.on 'data', (chunk)->
    result += chunk.toString()
  ag_cmd.on 'close', (code, signal)->
    console.log code, signal
    entries = parse_result path, result
    cb(entries)

exports.ag = ag
