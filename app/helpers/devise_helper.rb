module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty? and flash.empty?
    raw render(partial: 'devise/shared/error_messages', resource: resource, flash: flash)
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end
