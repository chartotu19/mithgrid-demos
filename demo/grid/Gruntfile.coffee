module.exports = (grunt)->
	#Project configuration
	grunt.initConfig
		pkg : grunt.file.readJSON "package.json"
		concat:
			options:
				stripBanners : true
				banner: '/*! <%= pkg.name %> - v<%= pkg.version %> */'
        	
   dist:
        		src:['src/app.js','src/drive.js','components/jquery/jquery.js','components/bootstrap/docs/assets/js/bootstrap.js']
        		dest: 'src/<%= pkg.name %>.js'

		uglify:
			options:
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			build:
				src:'src/<%= pkg.name %>.js'
				dest:'build/<%= pkg.name %>.min.js'

	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-concat'

	grunt.registerTask 'default', ['uglify']

	grunt.registerTask 'build', ['concat','uglify']
