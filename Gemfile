source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.1.0'
# adiciona compatibilidade com psych 4 para evitar erros de safe_load
gem "psych", "~> 4.0"

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'

# Use Puma as the app server
gem 'puma', '~> 6.4'

# Build JSON APIs with ease
gem 'jbuilder', '~> 2.11'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 5.0'

# Use Kredis to get higher-level data types in Redis
# gem 'kredis'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants
# gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors'

# PostGIS extension for PostgreSQL
gem 'activerecord-postgis-adapter', '~> 9.0'
gem 'rgeo-geojson', '~> 2.1'

# Rate limiting
gem 'rack-attack', '~> 6.7'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'pry-rails'
end

group :development do
  # Speed up commands on slow machines / big apps
  # gem 'spring'
end
