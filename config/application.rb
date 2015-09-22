require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HarvestmanBackend
  class Application < Rails::Application
    Dir.glob("#{Rails.root.join("bower_components")}/**/").sort.each do |dir|
      config.assets.paths << dir
    end

    config.autoload_paths += Dir["#{config.root}/app/presenters/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
