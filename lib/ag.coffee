spawn = require('child_process').spawn


parse_result = (result)->
  console.log "'" + result + "'"
  lines = result.split('\n')
  lines = lines.filter (line)->
    line != ''
  entries = lines.map (line)->
    matched = line.match(/^(.*?)\:(.*)$/)
    if matched
      [matched[1], matched[2]]
    else
      ['error', line]
  return entries

ag = (pattern, path, cb)->
  ag_cmd = spawn('ag', [pattern, path])

  result = ''
  ag_cmd.stdout.on 'data', (chunk)->
    result += chunk.toString()
  ag_cmd.on 'close', (code, signal)->
    console.log code, signal
    entries = parse_result result
    cb(entries)

exports.ag = ag
