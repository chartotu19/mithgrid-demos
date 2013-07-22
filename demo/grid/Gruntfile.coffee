module.exports = (grunt)->
	#Project configuration
	grunt.initConfig
		pkg : grunt.file.readJSON "package.json"

		coffee:
			compile:
				files:
					"src/app.js" : "src/app.coffee"
					"src/drive.js":"src/drive.coffee"
					"src/graph.js":"src/graph.coffee"
		concat:
			options:
				stripBanners : true
				banner: '/*! <%= pkg.name %> - v<%= pkg.version %> */'
        	
   dist:
        		src:['components/nvd3/lib/d3.v2.js','components/nvd3/nv.d3.min.js','components/jquery/jquery.js','components/bootstrap/docs/assets/js/bootstrap.js','../../dist/mithgrid.js','src/graph.js','src/app.js','src/drive.js']
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
