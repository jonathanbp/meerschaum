// Generated by CoffeeScript 1.6.1
(function() {
  var StreamQueuer,
    _this = this,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  StreamQueuer = (function(_super) {

    __extends(StreamQueuer, _super);

    function StreamQueuer(stream, parser) {
      var _this = this;
      this.stream = stream;
      this.parser = parser;
      this.emitAndPurge = function() {
        return StreamQueuer.prototype.emitAndPurge.apply(_this, arguments);
      };
      this.items = [];
      this.buffer = '';
      this.stream.resume();
      this.stream.setEncoding('utf8');
      this.stream.on('end', function() {
        _this.done = true;
        clearInterval(_this.pushEvents);
        _this.pushEvents = null;
        return _this.emitAndPurge();
      });
      this.stream.on('data', function(line) {
        var lines, tobuffer, _fn, _i, _len;
        if (line === '\n') {
          if ((_this.buffer != null) && _this.buffer !== '') {
            _this.items.push(_this.buffer);
            _this.buffer = '';
          } else {
            return;
          }
        }
        if (line.indexOf('\n') > 0) {
          lines = line.split('\n');
          if (lines[line.length - 1] !== '') {
            tobuffer = lines.pop();
          }
          if ((_this.buffer != null) && _this.buffer !== '') {
            _this.items.push(_this.buffer + lines.shift());
            _this.buffer = '';
          }
          _fn = function(line) {
            if (line !== '') {
              return _this.items.push(line);
            }
          };
          for (_i = 0, _len = lines.length; _i < _len; _i++) {
            line = lines[_i];
            _fn(line);
          }
          if (tobuffer != null) {
            return _this.buffer += tobuffer;
          }
        } else {
          return _this.buffer += line;
        }
      });
      this.on('newListener', function() {
        if (_this.pushEvents == null) {
          return _this.pushEvents = setInterval(_this.emitAndPurge, 500);
        }
      });
    }

    StreamQueuer.prototype.emitAndPurge = function() {
      var item, _results,
        _this = this;
      if (this.done && this.items.length === 0) {
        this.emit('end');
      }
      if (this.listeners('data').length > 0) {
        _results = [];
        while (item = this.items.shift()) {
          _results.push((function(item) {
            return _this.emit('data', item);
          })(item));
        }
        return _results;
      }
    };

    return StreamQueuer;

  })(require('events').EventEmitter);

  exports.StreamQueuer = StreamQueuer;

}).call(this);
