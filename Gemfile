# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake'
gem 'yard'

group :test do
  gem 'rspec'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'bump'
  gem 'rubocop', require: false
end

group :development, :test do
  gem 'byebug', platforms: :ruby
end

gemspec
