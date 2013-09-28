module.exports = (grunt)->
  #Project configuration
  grunt.initConfig
    pkg : grunt.file.readJSON "package.json"

    coffee:
      compile:
        files:
          "js/app.js" : "js/app.coffee"
          "js/controllers/mouseEvents.js": "js/controllers/mouseEvents.coffee"
          "js/presentations/list.js":"js/presentations/list.coffee"
    concat:
      options:
        stripBanners : true
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> */'
      dist:
          src:[
            'bower_components/todomvc-common/base.js',
            'bower_components/jquery/jquery.js',
            'js/mithgrid.js',
            #CONTROLLERS
            'js/controllers/mouseEvents.js'
            #PRESENTATIONS
            'js/presentations/list.js'
            #APP
            'js/app.js',
          ]
          dest: 'js/<%= pkg.name %>.js'


  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'build', ['coffee','concat']
