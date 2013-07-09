require 'angularjs-rails'
require 'angularjs-rails-cdn/version'

module AngularJS::Rails::Cdn
  module ActionViewExtensions
    ANGULARJS_VERSION = AngularJS::Rails::VERSION
    OFFLINE = (Rails.env.development? or Rails.env.test?)

    URL = {
      google: '//ajax.googleapis.com/ajax/libs/angularjs/{{VERSION}}/{{LIBRARY}}.min.js'
    }

    def angularjs_url(name, module_name, version)
      URL[name].gsub('{{VERSION}}', version).gsub('{{LIBRARY}}', module_name.to_s)
    end

    def angularjs_include_tag(name, options = {})
      version = options[:version] || ANGULARJS_VERSION

      local_includes = modules(options[:modules]).map { |m| javascript_include_tag(m) }.join

      return local_includes if OFFLINE and !options[:force]

      cdn_includes = modules(options[:modules]).map do |m|
        javascript_include_tag(angularjs_url(name, m, version),options)
      end.join

      [ cdn_includes,
        javascript_tag("window.angular || document.write(unescape('#{local_includes.gsub('<','%3C')}'))", options)
      ].join.html_safe
    end


    private

    def modules(submodules)
      [:angular] + (submodules || []).map { |m| :"angular-#{m}" }
    end
  end

  class Railtie < Rails::Railtie
    initializer 'angularjs_rails_cdn.action_view' do |app|
      ActiveSupport.on_load(:action_view) do
        include AngularJS::Rails::Cdn::ActionViewExtensions
      end
    end
  end
end
