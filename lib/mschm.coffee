# /usr/bin/env coffee

#### MEERSCHAUM ü_ ####
# 
# A fancy pipe.
# 
#######################

fs = require 'fs'
colors = require 'colors'
StreamQueuer = require('./StreamQueuer.js').StreamQueuer
DisplayServer = require('./DisplayServer.js').DisplayServer

views = fs.readdirSync(__dirname + '/public/views')

# parse arguments
argv = require('optimist')
  .usage('Usage: $0 -v [view] -p [port]')
  .options(
    v:
      alias: 'view',
      describe: 'The type of view to generate.'
      required: true
    p:
      alias: 'port'
      describe: 'The port from which the view is served.'
      default: 9999
  )
  .check(
    (argv) ->
      if views.indexOf(argv['v']) < 0 then throw "\"#{argv["v"]}\" not supported for view. Must be one of; #{views.join(",")}."
  )
  .argv


# create new StreamQueuer to read from stdin
sq = new StreamQueuer(process.stdin)
sq.on 'end', -> 
  process.stdout.write "<< EOF\n".green
  process.exit 0

# start server 
ds = new DisplayServer(argv['v'], sq)
ds.run(argv['p'])

# echo back to stdout (for chaining)
process.stdin.on('data', (d) -> process.stdout.write(d))
