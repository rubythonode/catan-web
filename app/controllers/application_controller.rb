class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include PartiSsoClient::Authentication
  before_action :verify_authentication

  if Rails.env.staging?
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end
end
