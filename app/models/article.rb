class Article < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable
  validates :title, presence: true
  validates :body, presence: true
  scope :recent, -> { order(created_at: :desc) }

  before_validation :auto_title

  def origin
    self
  end

  def auto_title
    return if self.title.present? and self.title != self.link

    if self.link.present?
      crawling_link = Link.find_or_create_by!(url: self.link)
      crawling_link.crawl_async
      self.title = crawling_link.title
      return if self.title.present?
    end
    return if self.body.blank?
    first_line = self.body.split("\n")[0]
    self.title ||= (first_line.scan(/[^\.!?]+[\.!?]/).first || first_line).strip
  end
end
