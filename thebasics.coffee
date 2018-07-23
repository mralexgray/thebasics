

global.log = console.log

###
# global['_'] = require 'underscore.string'

{
	'bodyParser'
}
###

for x in [['_','underscore'],['__','underscore.string'],['preq','parent-require'],
	'util','fs','path','arrayize']
	global[Array.isArray(x) and x[0] or x] = require Array.isArray(x) and x[1] or x


class Basics
	###*
	* @param {*} obj string, array, or array of arrays like 'path' or or ['p','path'] or ['path','util'] or ['coffee','@script']
	* @return {*} array of required stuff
	###
	@need: (obj) ->
		# console.log module.parent
		z = arrayize obj
		z.map (x) ->
			name = _.isArray(x) and x[0]  or x
			mod = _.isArray(x) and x[1] or x
			mod =  mod.replace '@', name
			global[name] = preq mod
	
	@initApp: (lrdirs = [], iconDir) ->
		global.express = preq 'express'
		global.app = express()
		[assets,fs,session,global.browserify,favicons] = @need ['connect-assets','fs','express-session','browserify-middleware', 'connect-favicons']
		# MemoryStore = session.MemoryStore
		FileStore = require('session-file-store')(session);

		app.icons = (dir) -> app.use favicons(fs.realpathSync(dir))
		app.use assets()
		app.use session(
				store: new FileStore()
				secret: 'keyboard cat'
				saveUninitialized: true
				resave: false)

		# app.use require('cookie-parser')('something secret')
		# app.use session(
		#   secret: 'yet another secret'
		# store: new MemoryStore
		# resave: true
		# saveUninitialized: true)

		app.livereload = require 'livereload'

		curdir = path.join process.cwd(), '**'
		console.log "[livereload] watching path #{lrpath}"
		global['lrserver'] = app.livereload.createServer
			exts: ['css', 'pug', 'styl', 'jade', 'cson']
			debug: true
		.watch _.concat([curdir, "#{process.cwd()}/assets"], lrdirs)
		
		app.set 'view engine', 'pug'
		app.locals.pretty = true

		browserify.settings 'transform', ['coffeeify']
		app
	@readJSON: (json) ->
		realpath = fs.realpathSync json
		JSON.parse(fs.readFileSync(realpath))
		
	@servePaths: (app,paths) -> app.use '/', express.static(path) for path in paths 	


module.exports = global.thebasics = Basics
