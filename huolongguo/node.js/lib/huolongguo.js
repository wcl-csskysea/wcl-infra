// Define HuoLongGuo server

var __ = require('./underscore.js');

var LOGGER = function(msg) {
  console.log((new Date().toTimeString().slice(0,8)) + " - " + msg);
}

var HuoLongGuo = function(conf) {
  if (!conf) { throw Error("Missing Configuration") };
  this.conf = conf;
  
  var HuoLongGuo = this;
}

HuoLongGuo.prototype = {
   run: function() {
     var HuoLongGuo = this;
     LOGGER("HuolOngGuo is running !");
     
     var Site = require('./site.js').Site;
     
     LOGGER(JSON.stringify(HuoLongGuo.conf.server.sites));
     
     __(HuoLongGuo.conf.server.sites).forEach(function(site_def,label){
       // apply server defaults if not defined in Site
       if (!site_def.name) { site_def.name = label }
       if (!site_def.mysql) { site_def.mysql = HuoLongGuo.conf.server.mysql }
       if (!site_def.git) { site_def.git = HuoLongGuo.conf.server.git }
       
       var site = new Site(site_def);
       site.run();
     });
   
   }
  
}

exports.HuoLongGuo = HuoLongGuo;