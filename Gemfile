source :gemcutter

gem 'rails', '>= 3.0.3'
gem "couchmodel", :require => "couch_model"
gem 'jquery-rails'
gem 'coderay'
gem 'haml'

if RUBY_PLATFORM =~ /java/
  gem "json-jruby"
  gem "jruby-openssl"
end

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
  gem "rspec-rails", ">= 2.3.0"
  gem 'ruby-debug19' unless RUBY_PLATFORM =~ /java/
  gem "autotest"
end
