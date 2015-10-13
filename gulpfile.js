var	gulp           = require('gulp'),
    elm            = require('gulp-elm'),
    sass           = require('gulp-sass'),
    browserSync    = require('browser-sync');

var paths = {
    elm : "./src/*.elm",
    main : "./src/Main.elm",
    rest : ['src/*.{html,js,png}'],
    sass: 'src/*.scss',
    dist : 'dist/',
    distWatch : ['dist/*', '!dist/*.css']
}

gulp.task('copy', function() {
    return gulp.src(paths.rest)
        .pipe(gulp.dest(paths.dist));
});

gulp.task('sass', function() {
	return gulp.src(paths.sass)
	.pipe(sass().on('error', sass.logError))
	.pipe(gulp.dest(paths.dist))
	.pipe(browserSync.stream()); 			// injects new styles with page reload!
});

gulp.task('elm-init', elm.init);

gulp.task('compile', ['elm-init'], function() {
    return gulp.src(paths.main)
        .pipe(elm())
        .pipe(gulp.dest(paths.dist));
})

gulp.task('serve', function() {
	browserSync.init({
        server: {
            baseDir: paths.dist
        }
	});
});

gulp.task('watch', ['serve'], function() {
    gulp.watch(paths.elm, ['compile']);
    gulp.watch(paths.rest, ['copy']);
    gulp.watch(paths.sass, ['sass']);
    gulp.watch(paths.distWatch).on('change', browserSync.reload);
});

gulp.task('default', ['compile', 'copy', 'sass', 'watch']);
