require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HarvestmanBackend
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins /http(s?):\/\/(.*?)\.industrialmusicelectronics\.com/
        resource '*', :headers => :any, :methods => [:get, :post, :options, :delete, :put]
      end
    end

    config.autoload_paths += Dir["#{config.root}/app/presenters/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
