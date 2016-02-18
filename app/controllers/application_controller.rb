class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include PartiSsoClient::Authentication
  before_action :verify_authentication

  if Rails.env.staging?
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  helper_method :issue_home_path, :tag_home_path
  def issue_home_path(issue)
    view_context.slug_issue_path(slug: issue.title)
  end

  def tag_home_path(tag)
    view_context.show_tag_path(name: tag.name)
  end
end
