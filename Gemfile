source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'pg', '0.15.1'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'
gem 'rack-cors', require: 'rack/cors'
gem 'activesupport-json_encoder'
gem 'devise', '3.5.2'

# # file uploads
# gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
# gem 'fog', require: 'fog/aws'
# gem 'unf'

# file uploads
gem 'fog-aws'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem "unf"

# tags
gem 'acts-as-taggable-on'

#search
gem 'textacular'

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
