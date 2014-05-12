source "https://rubygems.org"

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem "rails", "4.0.2"
gem "sass-rails", "~> 4.0.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"

group :doc do
  gem "sdoc", require: false
end

group :development do
  gem "thin"
  gem "debugger"
end

gem "normalize-rails"
gem "modernizr-rails"
gem "foundation-rails"
gem "foundation-icons-sass-rails"
gem "haml-rails"
gem "simple_form"
gem "select2-rails"
gem "multi-select-rails"

gem "devise"
gem "devise-async"
gem "mongoid", github: "mongoid/mongoid"
gem "roo"
gem "redis", "~> 3.0.1"
gem "hiredis", "~> 0.4.5"
gem "foreman"

# File upload
gem "carrierwave"
gem "carrierwave-mongoid", require: "carrierwave/mongoid"
gem "mongoid-grid_fs", github: "ahoward/mongoid-grid_fs"

# Jobs
gem "sinatra", ">= 1.3.0", require: nil
gem "sidetiq"
gem "sidekiq"
gem "chronic"

# Application server
gem "unicorn", '~> 4.6.3', group: :unicorn
