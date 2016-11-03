var gulp       = require('gulp');
var coffeelint = require('gulp-coffeelint');
var stylus     = require('gulp-stylus');
var uglify     = require('gulp-uglify');

var browserify = require('browserify');
var coffeeify  = require('coffeeify');
var del        = require('del');
var buffer     = require('vinyl-buffer');
var vinyl      = require('vinyl-source-stream');
var deploy 	   = require('gulp-gh-pages');
var paths = {
    assets: [
        './app/assets/**/*.*',
        './app/index.html'
    ],
    app: './app',
    dist: './dist',
    css: './app/css/main.styl',
    js: './app/js/app.coffee',
    lint: './app/js/*.coffee',
    deploy: './dist/**/*'
};

gulp.task('lint', function() {
    return gulp.src(paths.lint)
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffeelint.reporter('failOnWarning'));
});

gulp.task('clean', function() {
    return del(paths.dist);
});

gulp.task('copy-assets', function() {
    return gulp.src(paths.assets, {base: paths.app})
        .pipe(gulp.dest(paths.dist));
});

gulp.task('compile-css', function() {
    console.log(paths.css)
    return gulp.src(paths.css)
        .pipe(stylus({
            compress: true
        }))
        .pipe(gulp.dest(paths.dist));
});

gulp.task('compile-js', function() {
    return browserify(paths.js)
        .transform(coffeeify)
        .bundle()
        .pipe(vinyl('main.js'))
        .pipe(buffer())
        .pipe(uglify())
        .pipe(gulp.dest(paths.dist));
});

gulp.task('default', ['clean'], function() {
    gulp.run('copy-assets', 'compile-css', 'compile-js');
});

gulp.task('deploy', function() {
    return gulp.src(paths.deploy)
        .pipe(deploy());
});