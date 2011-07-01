/**
 * 
 */
var exec = require('child_process').exec;


var Git = function (conf) {
  if (!conf) { throw Error("Missing Git Configuration") };
  this.conf = conf;
  
  // define Git command line
//  this.binary_exec = 'mysql' + ' -u ' + conf.user + ' -p' + conf.pass + ' -h ' + conf.host + ' -P ' + conf.port;
  
  var Git = this;
};

Git.prototype = {
  // clone existing project - initial checkout
  clone: function () {
    var Git = this;
      git clone + Git.conf.repository + ' ' + Git.conf.folder
  },
  
  // pull new version of same branch
  pull: function () {
    var Git = this;
      git pull
  },
  
  // check for available new release
  check: function() {
    var Git = this;
      git 
  },
  
  list_branch: function() {
    var Git = this;
      git branch -all
  }
  
  // move to another branch 
  checkout: function() {
    var Git = this;
      git checkout + ''
  }

};

exports.Git = Git;

