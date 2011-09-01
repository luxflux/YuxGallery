source 'http://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'right-rails'
gem 'devise'
gem 'friendly_id', "~> 4.0.0.beta8"
gem 'carrierwave'
gem 'mini_magick'
gem 'delayed_job'
gem 'exifr'
gem 'cancan'
gem 'haml-rails'
gem 'uglifier'
gem 'therubyracer'

group :production do
  gem 'pg'
end

# Use unicorn as the web server
#gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem 'annotate'
  gem 'sqlite3'
end
group :development, :test do
  gem 'rspec-rails'
  gem 'watchr'
  gem 'spork', '~> 0.9.0.rc'
  gem 'factory_girl_rails', "~> 1.1.rc1"
  gem 'rcov'
  gem 'capybara'
  gem 'mocha'
  gem 'rspec-rails-mocha'
  gem 'sqlite3'
end
