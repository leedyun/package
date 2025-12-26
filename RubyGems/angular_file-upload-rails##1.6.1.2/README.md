Angular-File-Upload-Rails
=========================

A gem that includes [angular-file-upload](https://github.com/danialfarid/angular-file-upload) as an asset in the Rails Asset Pipeline (requires Rails 3.1 or higher).

Installation
------------

Add the gem to your **Gemfile**:

``` ruby
gem 'angular-file-upload-rails', '~> 1.6.1.1'
# The gem's version mirrors the included version of angular-file-upload,
# with an extra .1 for updates independent of the wrapped library's version.
```

and run:

```
$ bundle install
```

Lastly, be sure to include it in your JavaScript manifest (e.g. `application.js`)

```
//= require angular-file-upload
```
\* *be sure that angular is required before angular-file-upload*

**Important**: According to the angular-file-upload readme, if you wish to use the shim to support upload progress / abort for HTML5 and non-HTML5 FormData browsers, the shim javascript file must be included *before* angular.js, while the regular angular-file-upload being required after angular.  For example in `application.js`:

```
//= require angular-file-upload/angular-file-upload-shim
//= require angular
//= require angular-file-upload
```
