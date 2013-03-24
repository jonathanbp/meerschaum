# /usr/bin/env coffee

#### MEERSCHAUM ü_ ####
# 
# A fancy pipe.
# 
#######################

fs = require 'fs'
StreamQueuer = require('./StreamQueuer.js').StreamQueuer
DisplayServer = require('./DisplayServer.js').DisplayServer

displays = fs.readdirSync(__dirname + '/public/displays')

# parse arguments
argv = require('optimist')
  .usage('Usage: $0 -d [display] -p [port]')
  .options(
    d:
      alias: 'display',
      describe: 'The type of display to generate.'
      required: true
    p:
      alias: 'port'
      describe: 'The port from which the display is served.'
      default: 9999
  )
  .check(
    (argv) ->
      if displays.indexOf(argv['d']) < 0 then throw "\"#{argv["d"]}\" not supported for display. Must be one of; #{displays.join(",")}."
  )
  .argv


# create new StreamQueuer to read from stdin
sq = new StreamQueuer(process.stdin)

# start server 
ds = new DisplayServer(argv['d'], sq)
ds.run(argv['p'])

# echo back to stdout (for chaining)
process.stdin.on('data', (d) -> process.stdout.write(d))
