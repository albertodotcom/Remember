module.exports = (grunt) ->
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-nodemon')
	grunt.loadNpmTasks('grunt-inject')
	grunt.loadNpmTasks('grunt-concurrent')
	grunt.loadNpmTasks('grunt-node-inspector')

	grunt.initConfig
		concurrent:
		  dev:
		    tasks: ['nodemon', 'node-inspector', 'watch']
		    options:
		      logConcurrentOutput: true

		'node-inspector':
  			dev:
  				'web-port': 8080
  				'web-host': 'localhost'
  				'debug-port': 5455

		nodemon:
		  dev:
		    script: 'bin/www'
		    options:
		      nodeArgs: ['--debug']
		      env:
		        PORT: '5455'
		      
		      # omit this property if you aren't serving HTML files and 
		      # don't want to open a browser tab on start
		      callback: (nodemon) ->
		        nodemon.on 'log', (event) ->
		          console.log(event.colour)

		        # opens browser on initial server start
		        nodemon.on 'config:update', () ->
		          # Delay before server listens on port
		          setTimeout( () ->
		            require('open')('http://localhost:5455')
		          , 1000)

		        # refreshes browser when server reboots
		        nodemon.on 'restart', () ->
		          # Delay before server listens on port
		          setTimeout () ->
		            require('fs').writeFileSync('.rebooted', 'rebooted')
		          , 1000
		      
		watch:
		  nodemon:
		    files: ['bin/**/*', 'models/**/*', 'public/**/*', 'routes/**/*', 'views/**/*', 'app.coffee', 'db.coffee']
		    options:
		      livereload: true

	grunt.registerTask 'default', ['concurrent:dev']