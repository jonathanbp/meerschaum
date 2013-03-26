express = require 'express'

class DisplayServer

  constructor: (@view, @streamqueuer) ->
    
    @app = express()

    @server = require('http').createServer(@app)
    @io = require('socket.io').listen(@server)

    @io.set('log level', 0)

    # public dir is used to serve static files
    @app.use(express.static(__dirname + '/public'))

    # less compiler
    @app.use(require('less-middleware')({ src: __dirname + '/public' }))

    @app.get('/', 
      (req, res) =>
        res.sendfile(__dirname + "/public/views/#{@view}/index.html")
    )

    # when socket connection then connect streamqueuer with socket
    @io.sockets.on('connection', 
      (socket) =>
        # connect stream and socket
        @streamqueuer.on('data', 
          (data) ->
            socket.emit('data', data)
        )
        # socket.on('otherevent', (d) -> console.log d)
    )


  run: (port) -> @server.listen(port)

# exports
exports.DisplayServer = DisplayServer