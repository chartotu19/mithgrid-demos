module.exports = (grunt)->
	#Project configuration
	grunt.initConfig
		pkg : grunt.file.readJSON "package.json"

		coffee:
			compile:
				files:
					"src/app.js" : "src/app.coffee"
					"src/drive.js":"src/drive.coffee"
		concat:
			options:
				stripBanners : true
				banner: '/*! <%= pkg.name %> - v<%= pkg.version %> */'
        	
   dist:
        		src:['components/jquery/jquery.js','../../dist/mithgrid.js','src/app.js','src/drive.js','components/bootstrap/docs/assets/js/bootstrap.js']
        		dest: 'src/<%= pkg.name %>.js'

		uglify:
			options:
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			build:
				src:'src/<%= pkg.name %>.js'
				dest:'build/<%= pkg.name %>.min.js'

	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-coffee'

	grunt.registerTask 'default', ['uglify']

	grunt.registerTask 'build', ['coffee','concat','uglify']
