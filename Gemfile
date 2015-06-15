source 'https://rubygems.org'

ruby "2.2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
#gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', '~> 0.4.0', group: :doc


gem "puma"
gem "foreman"
gem "versionist"
gem 'active_hash_relation', github: 'kollegorna/active_hash_relation'
gem 'devise', '~> 3.4.1'

gem "devise_openid_authenticatable"
gem 'ruby-openid'
gem 'open_id_authentication'

gem 'pundit'

gem 'rack-cors', :require => 'rack/cors'

gem 'kaminari', '~> 0.16.1'

gem 'friendly_id', '~> 5.1.0'

gem 'redis-throttle', git: 'git://github.com/andreareginato/redis-throttle.git'
gem 'rspec-api_helpers', github: 'kollegorna/rspec-api_helpers'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


# gem 'active_model_serializers', '0.9.2'
 gem 'active_model_serializers', github: "rails-api/active_model_serializers"

 gem 'impressionist'


 gem "paperclip", "~> 4.2"

gem 'paperclip-av-transcoder'

gem 'delayed_job_active_record'
gem 'delayed_paperclip'

# gem 'paperclip-av-qtfaststart'

gem 'acts-as-taggable-on', '~> 3.4'

group :development do

  gem 'annotate', branch: 'develop'

end
gem 'pry-rails'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.1.0'
  gem 'faker'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'database_cleaner', '~> 1.3.0'
end

group :production do
  gem "rails_12factor"

end
