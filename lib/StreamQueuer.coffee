class StreamQueuer extends require('events').EventEmitter

  constructor: (@stream) -> 
    @items = [] 
    @buffer = ''

    @stream.resume()
    @stream.setEncoding 'utf8'

    @stream.on 'end', =>
      @done = true
      clearInterval(@pushEvents)
      @pushEvents = null
      @emitAndPurge()


    # when data is received from stream queue it up
    @stream.on 'data', (line) =>

      # if we see a single \n then add buffer to items and return
      if line is '\n' 
        if @buffer? and @buffer isnt ''
          @items.push @buffer
          @buffer = ''
        else return

      if line.indexOf('\n') > 0 
        lines = line.split '\n'

        # if last item isnt \n then we havent got full lines
        if lines[line.length-1] isnt ''
          tobuffer = lines.pop()

        # if there is something in the buffer then we need to complete it
        if @buffer? and @buffer isnt ''
          @items.push(@buffer + lines.shift())
          @buffer = ''

        for line in lines 
          do (line) => 
            if line isnt ''
              @items.push line

        # if there is something in tobuffer then append
        if tobuffer? then @buffer += tobuffer

      else 
        @buffer += line

    @on 'newListener', =>
      if not @pushEvents? then @pushEvents = setInterval(@emitAndPurge, 500)


  emitAndPurge: (listeners) =>
    if @done and @items.length is 0 then @emit('end')
    if @listeners('data').length > 0
      while item = @items.shift()
        do (item) =>
          @emit('data', item)


exports.StreamQueuer = StreamQueuer