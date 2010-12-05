source 'http://rubygems.org'
source :gemcutter

gem 'rails', '>= 3.0.3'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "couchmodel", :require => "couch_model"
gem 'jquery-rails'

gem "json-jruby" if RUBY_PLATFORM =~ /java/
gem 'ultraviolet', :git => 'git://github.com/spox/ultraviolet' unless RUBY_PLATFORM =~ /java/

# gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem "rspec-rails", ">= 2.0.0"
  gem 'ruby-debug19' unless RUBY_PLATFORM =~ /java/
  gem "autotest"
end
