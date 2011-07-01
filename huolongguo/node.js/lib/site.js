// Define the base huolongguo actions

// Load modules
var fs = require('fs');
var path = require('path');

// Load helper function for logging
var LOGGER = function(msg) {
  console.log((new Date().toTimeString().slice(0,8)) + " - " + msg);
}


var Site = function(conf) {
  if (!conf) { throw Error("Missing Configuration") };
  this.conf = conf;
  this.conf.webroot = '/var/www/' + conf.name;
  this.conf.dbname = conf.name.replace('.', '_');
  
  var Site = this;
}

Site.prototype = {
  // Create new site
  create: function() {
    var Site = this;
    
    // Create folder for webroot
    path.exists(Site.webroot, function(exists) {
      if (! exists) {
        fs.mkdir(Site.webroot, function(err){
          if (err) { throw err };
        });
      }
      else {
        throw Site.webroot + ' already exists !';
      };
    });
    
    // Create database - load MySQL object and run query for DB create
    var MySQL = require('./mysql.js').MySQL;
    mysql = new MySQL(Site.conf.mysql);
    mysql.query('CREATE DATABASE ' + Site.db_name);
    
    // First data import
    var Git = require('./git.js').Git;
    git = new Git(Site.conf.git);
    git.clone();
    
    // Call site.update
    Site.update();
    
    // Call site.import
    Site.import();
  },
  
  // Destroy site - Erase all data
  destroy: function() {
    var Site = this;
  },

  // Update site - code only
  update: function() {
    var Site = this;    
  },
  
  // Backup site
  backup: function () {
    var Site = this;
  },
  
  // Import - DB only
  import: function () {
    var Site = this;
  },
  
  // Export - DB only
  export: function () {
    var Site = this;
  }
  
  
//  run: function() {
//    var Site = this;
//    LOGGER("site " + Site.conf.name + " is running !");
//    LOGGER("mysql info : " + Site.conf.mysql.user);
//    
//    var MySQL = require('./mysql.js').MySQL;
//    var mysql = new MySQL(Site.conf.mysql);
//    
//    mysql.run('USE mysql; SELECT * FROM user;');
//    data = mysql.execute('USE mysql; SELECT user, host, password FROM user WHERE user=\'root\';');
//    console.log('data output : ' + data );
//  }
  
}

exports.Site = Site;