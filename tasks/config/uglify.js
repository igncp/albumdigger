/**
 * Minify files with UglifyJS.
 *
 * ---------------------------------------------------------------
 *
 * Minifies client-side javascript `assets`.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-uglify
 *
 */
module.exports = function(grunt) {
	grunt.config.set('uglify', {
		dist: {
      expand: true,
      cwd: '.tmp/public/js/digger/',
      src: '**/*.js',
      dest: '.tmp/public/js/digger/'
		}
	});

	grunt.loadNpmTasks('grunt-contrib-uglify');
};
