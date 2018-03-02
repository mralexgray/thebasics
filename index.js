
require('coffee-script/register')
// module.exports = function (sitename) { return require('./app')(sitename); }

me = './' + require('path').basename(__dirname) + '.coffee';
console.log('requiring ', me);
module.exports = require(me);
