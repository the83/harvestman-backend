source 'https://rubygems.org'
ruby "2.6.6"

gem 'rails', '6.0.0'
gem 'activerecord', '6.0.0'
gem 'actionpack', '6.0.0'
gem 'pg', '>= 0.18.0'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'
gem 'rack-cors', require: 'rack/cors'
gem 'devise', '4.7.2'
gem 'json', '2.5.1'
gem 'sprockets', '~>3.0'

# file uploads
gem 'fog-aws'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem "unf"

# tags
gem 'acts-as-taggable-on'

group :development do
  gem 'spring'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
end

group :production do
  gem 'rails_12factor', group: :production
end
