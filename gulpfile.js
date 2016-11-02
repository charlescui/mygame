var gulp       = require('gulp');
var coffeelint = require('gulp-coffeelint');
var stylus     = require('gulp-stylus');
var uglify     = require('gulp-uglify');

var browserify = require('browserify');
var coffeeify  = require('coffeeify');
var del        = require('del');
var buffer     = require('vinyl-buffer');
var vinyl      = require('vinyl-source-stream');
var paths = {
    assets: [
        './app/assets/**/*.*',
        './app/index.html'
    ],
    app: './app',
    dist: './dist',
    css: './app/css/main.styl',
    js: './app/js/app.coffee',
    lint: './app/js/*.coffee'
};

gulp.task('lint', function() {
    return gulp.src(paths.lint)
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffeelint.reporter('failOnWarning'));
});

gulp.task('clean', function(cb) {
    del(paths.dist, cb);
});

gulp.task('copy-assets', function() {
    return gulp.src(paths.assets, {base: paths.app})
        .pipe(gulp.dest(paths.dist));
});

gulp.task('compile-css', function() {
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
    gulp.start('copy-assets', 'compile-css', 'compile-js');
});

var deploy = require('gulp-gh-pages');

var paths = {
    // Other paths
    deploy: './dist/**/*'
};

gulp.task('deploy', function() {
    return gulp.src(paths.deploy)
        .pipe(deploy());
});