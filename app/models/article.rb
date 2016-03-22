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
    @auto_title_from_body = auto_title_from_body

    if self.link.present? and (self.title.blank? or (self.title == @auto_title_from_body))
      crawling_link = Link.find_or_create_by!(url: self.link)
      crawling_link.crawl_async
      self.title = crawling_link.title
    end

    self.title ||= @auto_title_from_body
  end

  def auto_title_from_body
    return '' if self.body.blank?
    first_line = self.body.split("\n")[0]
    (first_line.scan(/[^\.!?]+[\.!?]/).first || first_line).strip
  end
end
