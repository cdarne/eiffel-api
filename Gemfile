source 'https://rubygems.org'

gem 'rails', '4.1.2.rc1'
gem 'rails-api'
gem 'foreigner'
gem 'active_model_serializers'

# Memcached
gem 'dalli'
gem 'kgio'
gem 'rack-cache'

# JSON
gem 'multi_json'
gem 'oj'

group :development do
  gem 'spring'
  gem 'pry-rails'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'sqlite3'
end

group :production do
  gem 'passenger'
  gem 'pg'
  gem 'rails_12factor'
  gem 'memcachier'
end