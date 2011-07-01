//var util = require('util'),
var exec = require('child_process').exec;

function test(back){
  exec('cat */*/*.js xxc | wc -l',
    function (error, stdout, stderr) {
	back = stdout;  
  });
  return back;

//  console.log('cat: ' + cat);
//  console.log('stdout: ' + cat.out);
//  console.log('stderr: ' + cat.stderr);

//  if (cat.error !== null) {
//    console.log('exec error: ' + cat.error);
//  }
}

//test(back);

exports.test = test;

