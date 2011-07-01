
// First data import
var Class1 = require('./class1.js').Class1;
class1 = new Class1('test');

class1.addListener('sleep',class1.fct2());
class1.fct1();
