module ApplicationHelper
  def byline(user, options={})
    return if user.nil?
    raw render(partial: 'users/byline', locals: options.merge(user: user))
  end

  def fa_icon(name)
    content_tag(:i, nil, class: "fa fa-#{name}")
  end

  def date_f(date)
    if date.today?
      date.strftime("%H:%M")
    else
      date.strftime("%Y.%m.%d")
    end
  end

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?

    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end
end
