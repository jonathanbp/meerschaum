// Generated by CoffeeScript 1.6.1
(function() {
  var StreamQueuer, StringStream, should,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  should = require('should');

  StreamQueuer = require('../lib/StreamQueuer.js').StreamQueuer;

  StringStream = (function(_super) {

    __extends(StringStream, _super);

    function StringStream() {
      StringStream.__super__.constructor.call(this);
    }

    StringStream.prototype.write = function(s) {
      return this.emit('data', s);
    };

    StringStream.prototype.close = function() {
      return this.emit('end');
    };

    return StringStream;

  })(require('events').EventEmitter);

  describe('StreamQueuer', function() {
    it('should read lines from a stream and append them to a queue', function() {
      var sq, stream;
      stream = new StringStream();
      sq = new StreamQueuer(stream);
      stream.write('1 A\n');
      sq.should.have.property('items')["with"].lengthOf(1);
      sq.items[0].should.eql('1 A');
      stream.write('2');
      stream.write(' B\n');
      sq.items.should.have.length(2);
      sq.items[1].should.eql('2 B');
      stream.write('3');
      sq.items.should.have.length(2);
      stream.write(' C\n4');
      sq.items.should.have.length(3);
      stream.write(' D\n');
      sq.items.should.have.length(4);
      sq.items[2].should.eql('3 C');
      sq.items[3].should.eql('4 D');
      stream.write('5');
      sq.items.should.have.length(4);
      stream.write(' E\n6');
      sq.items.should.have.length(5);
      stream.write(' F');
      sq.items.should.have.length(5);
      stream.write('\n');
      sq.items.should.have.length(6);
      sq.items[4].should.eql('5 E');
      return sq.items[5].should.eql('6 F');
    });
    return it('should queue events and only empty queue when a listener connects', function(done) {
      var events, sq, stream;
      stream = new StringStream();
      sq = new StreamQueuer(stream);
      events = [];
      stream.write('A 1\n');
      stream.write('B 2\n');
      stream.write('C 3\n');
      sq.items.should.have.length(3);
      sq.on('data', function(d) {
        events.push(d);
        if (events.length === 4) {
          sq.items.should.have.length(0);
          return done();
        }
      });
      return stream.write('D 4\n');
    });
  });

}).call(this);
