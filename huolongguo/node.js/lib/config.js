// Read configuration file
// apply default if no configuration file

var DefaultConfig = '../etc/default.conf';
var fs = require('fs');
var path = require('path');

var configFileName = '';

// set configuration file name
function getConfigName(fileName){
    if ( ! fileName ) {
        fileName = DefaultConfig;
    }
    return fileName;
};

// read configuration file
function readConfig(fileName, content) {
    configFileName = getConfigName(fileName);
    path.exists(configFileName, function (exists) {
        if (!exists) {
            console.log(configFileName + ' doesn\'t exist');
        }
        content = fs.readFile(configFileName, 'utf8', parseConfig);
//        return content;
    });
};

function parseConfig(err, data) {
    if (err) throw err;
    console.log(data);
    content = 'Not Defined'
    try {
        content = JSON.parse(data);
        console.log("content: " + JSON.stringify(content));
        console.log("content data: " + content['user']);
        return content;
    }  
    catch (err) {
        console.log("error parsing " + configFileName + " : " + err);
    }
};

exports.readConfig = readConfig;

