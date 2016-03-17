class Article < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable
  validates :body, presence: true
  scope :recent, -> { order(created_at: :desc) }

  def origin
    self
  end
end
