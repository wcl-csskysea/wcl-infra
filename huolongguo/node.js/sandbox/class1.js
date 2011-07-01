/**
 * 
 */
var exec = require('child_process').exec;
var emitter = require('events').EventEmitter;

var Class1 = function (conf) {
  var Class1 = this;
  Class1.conf=conf;
};

Class1.prototype = {
  // clone existing project - initial checkout
  fct1: function () {
    var Class1 = this;
    console.log('fct1 : ' + Class1.conf);
    exec('sleep 1', function (error, stdout, stderr){
            Class1.conf='toto';
            emitter.emit('sleep');
//            return Class1;
        });
  },
  
  // pull new version of same branch
  fct2: function () {
    var Class1 = this;
    console.log('fct2 : ' + Class1.conf);      
  },
  
};

exports.Class1 = Class1;

