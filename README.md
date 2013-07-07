# angularjs-rails-cdn

[![Gem Version](https://badge.fury.io/rb/angularjs-rails-cdn.png)](https://badge.fury.io/rb/angularjs-rails-cdn)
[![Build Status](https://secure.travis-ci.org/styx/angularjs-rails-cdn.png?branch=master)](https://travis-ci.org/styx/angularjs-rails-cdn)
[![Dependency Status](https://gemnasium.com/styx/angularjs-rails-cdn.png)](https://gemnasium.com/styx/angularjs-rails-cdn)
[![Code Climate](https://codeclimate.com/github/styx/angularjs-rails-cdn.png)](https://github.com/styx/angularjs-rails-cdn)
[![Coverage Status](https://coveralls.io/repos/styx/angularjs-rails-cdn/badge.png?branch=master)](https://coveralls.io/r/styx/angularjs-rails-cdn)

Adds CDN support to

* [angularjs-rails](https://github.com/hiravgandhi/angularjs-rails).

Serving javascripts and stylesheets from a publicly available [CDN](http://en.wikipedia.org/wiki/Content_Delivery_Network) has clear benefits:

* **Speed**: Users will be able to download AngularJS from the closest physical location.
* **Caching**: CDN is used so widely that potentially your users may not
  need to download AngularJS and others at all.
* **Parallelism**: Browsers have a limitation on how many connections
  can be made to a single host. Using CDN for AngularJS offloads a big one.

## Features

This gem offers the following features:

* Can support multiple CDNs, but currently only Google provider is
  available.
* AngularJS version is automatically detected via angularjs-rails
  (can be overriden).
* Automatically fallback to angularjs-rails bundled AngularJS when:
  * You're on a development environment so that you can work offline.
  * The CDN is down or unavailable.

Implications of externalizing AngularJS from `application.js` are:

* Updating your JS code won't evict the entire cache in browsers - your
  code changes more often than AngularJS upgrades, right?
* `rake assets:precompile` takes less peak memory usage.

Changelog:

* v0.1.0: Initial release

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'angularjs-rails-cdn'
```

## Usage

This gem adds methods to generate a script tag to the AngularJS on a CDN of your preference:
`angularjs_include_tag` and `angularjs_url`

If you're using assets pipeline with Rails 3.1+, first remove `//= require angular` (or other special files if you are using not full version) from `application.js`.

Then in layout:

```ruby
= angularjs_include_tag :google,
= javascript_include_tag 'application'
```

Other possible usages:

```ruby
# To override version
= angularjs_include_tag :google, version: '1.1.5'
# To load additional AngularJS modules
= angularjs_include_tag :google, modules: [:resources,
:cookies]
```

Note that only valid CDN symbols is:

```ruby
:google
```

It will generate the following for AngularJS on production:

```html
<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
window.angular || document.write(unescape('%3Cscript src="/assets/angular-3aaa3fa0b0207a1abcd30555987cd4cc.js" type="text/javascript">%3C/script>'))
//]]>
</script>
```

on development:

```html
<script src="/assets/angular.js?body=1" type="text/javascript"></script>
```

If you want to check the production URL, you can pass `force: true` as an option.

```ruby
angularjs_include_tag :google, force: true
```

To fallback to rails assets when CDN is not available, add `angular.js` in `config/environments/production.rb`

```ruby
config.assets.precompile += %w( angular.js )
```
