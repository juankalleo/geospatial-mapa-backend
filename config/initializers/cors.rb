Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'
    resource '/api/*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: true
  end

  allow do
    origins '*'
    resource '/public/*', headers: :any, methods: %i[get options]
  end
end
