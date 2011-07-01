// handle all mysql requests

// Import extrernal modules
var exec = require('child_process').exec;

// Define object
var MySQL = function (conf) {
  if (!conf) { throw Error("Missing MySQL Configuration") };
  this._conf = conf;
  
  // define MySQL command line
  this.binary_exec = 'mysql' + ' -u ' + conf.user + ' -p' + conf.pass + ' -h ' + conf.host + ' -P ' + conf.port;
  
  var MySQL = this;
};

// Define MySQL prototype and its functions
MySQL.prototype = {
  
  // execute SQL query
  query: function (sql_query) {
    var MySQL = this;

    // Throw error if sql_query is missing
    if (!sql_query || sql_query === '') {throw Error("Missing SQL query")};
    
    // Execute query
    exec('echo \"' + sql_query + '\" | ' + MySQL.binary_exec, 
        function (error, stdout, stderr){
            console.log(stdout);
            console.log(stderr);
        });
  },
  
  // Perform MySQL backup via mysqldump
  backup: function (database) {
    var MySQL = this;
    // mysqldump only database
  },
  
  // Perform MySQL import
  import: function (file, database) {
    var MySQL = this;
    // Perform a full import of the SQL file into the database
  },

  // Create database
  create: function (database) {
    var MySQL = this;
    
  }

};

exports.MySQL = MySQL;