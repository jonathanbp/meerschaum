should = require 'should'
StreamQueuer = require('../lib/StreamQueuer.js').StreamQueuer

class StringStream extends require('events').EventEmitter
  constructor: () -> super()

  write: (s) ->
    @emit 'data', s

  close: -> @emit 'end'


describe 'StreamQueuer', ->
  it 'should read lines from a stream and append them to a queue', ->
    stream = new StringStream()
    sq = new StreamQueuer(stream)

    # write a single line
    stream.write('1 A\n')

    sq.should.have.property('items').with.lengthOf(1)
    sq.items[0].should.eql('1 A')

    # write a line across two requests
    stream.write('2')
    stream.write(' B\n')

    sq.items.should.have.length(2)
    sq.items[1].should.eql('2 B')

    # write two lines across three requests
    stream.write('3')
    sq.items.should.have.length(2)
    stream.write(' C\n4')
    sq.items.should.have.length(3)
    stream.write(' D\n')
    sq.items.should.have.length(4)

    sq.items[2].should.eql('3 C')
    sq.items[3].should.eql('4 D')

    # write two lines across four requests
    stream.write('5')
    sq.items.should.have.length(4)
    stream.write(' E\n6')
    sq.items.should.have.length(5)
    stream.write(' F')
    sq.items.should.have.length(5)

    # -- write completing \n
    stream.write('\n')
    sq.items.should.have.length(6)

    sq.items[4].should.eql('5 E')
    sq.items[5].should.eql('6 F')

  it 'should queue events and only empty queue when a listener connects', (done) ->

    stream = new StringStream()
    sq = new StreamQueuer(stream)
    events = []

    stream.write('A 1\n')
    stream.write('B 2\n')
    stream.write('C 3\n')

    # all items are retained in queue
    sq.items.should.have.length(3)

    sq.on 'data', (d) -> 
      events.push d
      if events.length is 4 
        sq.items.should.have.length(0)
        done()

    stream.write('D 4\n')





   
