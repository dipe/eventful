source :gemcutter

gem 'rails', '>= 3.0.5'
gem "couchmodel", :require => "couch_model"
gem 'jquery-rails'
gem 'coderay'
gem 'haml'
gem 'will_paginate'

if RUBY_PLATFORM =~ /java/
  gem "json-jruby"
  gem "jruby-openssl"
end

group :development, :test do
  gem "rspec-rails", ">= 2.3.0"
  gem 'ruby-debug19' unless RUBY_PLATFORM =~ /java/
  gem "autotest"
end
