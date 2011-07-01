#!/usr/local/bin/node

try {

  // Import HuoLongGuo, config
  var HuoLongGuo = require('../lib/huolongguo.js').HuoLongGuo;
  var config = require('../etc/huolongguo.conf').config;
  
  // Instantiate & run
  var huolongguo = new HuoLongGuo(config);
  huolongguo.run();

} 

catch (err) {
  console.log("ERROR: " + err);
  process.exit(1);
}