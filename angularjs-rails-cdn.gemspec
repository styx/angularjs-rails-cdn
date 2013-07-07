# coding: UTF-8
require File.expand_path('../lib/angularjs-rails-cdn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Mikhail Pobolovets']
  gem.email         = ['styx.mp@gmail.com']
  gem.description   = %q{Adds CDN support to angularjs-rails}
  gem.summary       = %q{Adds CDN support to angularjs-rails}
  gem.homepage      = 'https://github.com/styx/angularjs-rails-cdn'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "angularjs-rails-cdn"
  gem.require_paths = ['lib']
  gem.version       = AngularJS::Rails::Cdn::VERSION

  gem.add_dependency 'angularjs-rails'
  gem.add_dependency 'railties', '>= 3.0'

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'pry'
end
