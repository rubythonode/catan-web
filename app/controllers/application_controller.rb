class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :prepare_meta_tags, if: "request.get?"

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::AssetUrlHelper

  if Rails.env.staging?
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  helper_method :issue_home_path, :tag_home_path
  def issue_home_path(issue)
    view_context.slug_issue_path(slug: issue.slug)
  end

  def tag_home_path(tag)
    view_context.show_tag_path(name: tag.name)
  end

  def prepare_meta_tags(options={})
    site_name   = "빠띠"
    title       = "유쾌한 민주주의 플랫폼"
    description = "더 나은 민주주의의 기반요소를 통합한 기민하고, 섬세하고, 일상적인 민주주의 플랫폼, 빠띠!"
    keywords    = "정치, 민주주의, 조직, 투표, 모임, 의사결정, 일상 민주주의, 토의, 토론, 논쟁, 논의, 회의"
    image       = image_url(options[:image] || "parti-seo.png")
    current_url = request.url

    defaults = {
      site:        site_name,
      title:       title,
      reverse:     true,
      image:       asset_url(image),
      description: :description,
      keywords:    keywords,
      canonical:   current_url,
      twitter: {
        site_name: title,
        site: '@parti_xyz',
        card: 'summary',
        description: :description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: :description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)
    set_meta_tags options
  end


end
