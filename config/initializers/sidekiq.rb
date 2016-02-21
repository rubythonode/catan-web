Sidekiq.configure_server do |config|
  config.redis = {namespace: "catan_web:#{Rails.env}"}
end
Sidekiq.configure_client do |config|
  config.redis = {namespace: "catan_web:#{Rails.env}"}
end
