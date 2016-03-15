module OriginPostable
  extend ActiveSupport::Concern

  included do
    helper_method :origin_postable_controlling?
  end

  def origin_postable_controlling?
    try(:fetch_issue).present?
  end
end
