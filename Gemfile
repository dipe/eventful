source :gemcutter

gem 'rails'
gem "couchmodel", :require => "couch_model"
gem 'jquery-rails'
gem 'coderay'
gem 'haml'
gem 'sass'
gem 'will_paginate'

if RUBY_PLATFORM =~ /java/
  gem "json-jruby"
  gem "jruby-openssl"
end

group :development, :test do
  gem "rspec-rails"
  gem 'ruby-debug19' unless RUBY_PLATFORM =~ /java/
  gem "autotest"
end
