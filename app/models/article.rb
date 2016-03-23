class Article < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable

  belongs_to :link_source

  scope :recent, -> { order(created_at: :desc) }

  def origin
    self
  end

  def title
    link_source.present? ? (link_source.title || link_source.url)  : read_attribute(:title)
  end

  def body
    link_source.present? ? link_source.body : read_attribute(:body)
  end
end
