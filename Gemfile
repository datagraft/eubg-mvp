source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Make use of Boostrap for CSS 
gem 'bootstrap-sass', '3.3.7'
# Use rest-client, a simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete.
gem 'rest-client', '~> 2.0', '>= 2.0.2'
# Use HTTParty to capture responses, which in turn can be used to parse JSON responses
gem 'httparty', '0.13.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0' 
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#will_paginate provides a simple API for performing paginated queries with Active Record,
#DataMapper and Sequel, and includes helpers for rendering pagination links in Rails,
#Sinatra and Merb web apps.
gem 'will_paginate', '~> 3.1', '>= 3.1.5'
#Hooks into will_paginate to format the html to match Twitter Bootstrap styling. Extension 
#code was originally written by Isaac Bowen (https://gist.github.com/1182136).
gem 'bootstrap-will_paginate', '~> 0.0.10'
# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and
# sophisticated paginator for Rails 3+
#gem 'kaminari', '~> 0.16.3'
gem 'kaminari', :git => "git://github.com/amatsuda/kaminari.git", :branch => 'master'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
