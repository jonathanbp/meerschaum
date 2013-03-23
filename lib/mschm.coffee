# /usr/bin/env coffee

#### MEERSCHAUM ü_ ####
# 
# A fancy pipe.
# 
#######################

process.stdin.resume()
process.stdin.setEncoding 'utf8'

process.stdin.on('data', (chunk) -> process.stdout.write('data: ' + chunk))
process.stdin.on('end', -> process.stdout.write('end'))

