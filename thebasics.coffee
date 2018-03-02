

###
# global['_'] = require 'underscore.string'

{
	'bodyParser'
}
###

for x in [['_','underscore'],['__','underscore.string'],'util','path']
	global[Array.isArray(x) and x[0] or x] = require Array.isArray(x) and x[1] or x

m = {}

m.need = (obj) ->
		for x,y of obj
			# console.log "y, #{y} isa #{typeof y}"
			mod = y.replace '@',x
			global[x] = require mod

module.exports = m
