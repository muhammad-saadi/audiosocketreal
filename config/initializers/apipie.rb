Apipie.configure do |config|
  config.app_name                = "ArtistPortalBackend"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/documentation"
  config.namespaced_resources    = true
  config.validate = false
  config.translate = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
