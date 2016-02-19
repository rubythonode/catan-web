class Like < ActiveRecord::Base
  include PostTouchable

  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, presence: true
  validates :post, presence: true
  validates :user, uniqueness: {scope: [:post]}

  scope :recent, -> { order(created_at: :desc) }

  before_save :touch_post_by_like
end
