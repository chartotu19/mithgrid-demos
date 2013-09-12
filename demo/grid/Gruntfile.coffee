module.exports = (grunt)->
  #Project configuration
  grunt.initConfig
    pkg : grunt.file.readJSON "package.json"

    coffee:
      compile:
        files:
          "src/app.js" : "src/app.coffee"
          "src/drive.js":"src/drive.coffee"
          "src/controllers/mouseEvents.js": "src/controllers/mouseEvents.coffee"
          "src/presentations/spreadsheet.js":"src/presentations/spreadsheet.coffee"
          "src/presentations/graph.js":"src/presentations/graph.coffee"
          "src/presentations/editTable.js":"src/presentations/editTable.coffee"
          "src/importer.js":"src/importer.coffee"
          "src/exporter.js":"src/exporter.coffee"
    concat:
      options:
        stripBanners : true
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> */'

      dist:
            src:[
              'components/d3/d3.min.js',
              # 'components/nvd3/lib/d3.v2.js',
              'components/nvd3/nv.d3.min.js',
              # 'http://d3js.org/d3.v3.js',
              'components/jquery/jquery.js',
              'components/jquery-csv/src/jquery.csv.js'
              'components/bootstrap/docs/assets/js/bootstrap.js',
              'components/handsontable/dist/jquery.handsontable.full.js',
              'components/q/q.js',
              #'components/nvd3/nv.d3.js',
              '../../dist/mithgrid.js',
              #CONTROLLERS
              'src/controllers/mouseEvents.js'
              #PRESENTATIONS
              'src/presentations/graph.js',
              'src/presentations/spreadsheet.js',
              'src/presentations/tabs.js',
              'src/presentations/editTable.js'
              #APP
              'src/app.js',
              #Library components
              'src/drive.js',
              'src/exporter.js',
              'src/importer.js',
              'src/libs/Blob.js',
              'src/libs/FileSaver.js'
              
            ]
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

  grunt.registerTask 'build', ['coffee','concat']
