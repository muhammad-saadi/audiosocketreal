Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*', headers: :any, methods: %i[get post options put patch delete], credentials: false, max_age: 0
  end
end
