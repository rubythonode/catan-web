class Comment < ActiveRecord::Base
  include PostTouchable
  include Choosable

  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, presence: true
  validates :post, presence: true
  validates :body, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :persisted, -> { where "id IS NOT NULL" }

  before_save :touch_post_by_comment
end
