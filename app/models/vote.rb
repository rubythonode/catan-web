class Vote < ActiveRecord::Base
  extend Enumerize
  include PostTouchable
  include Choosable

  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, uniqueness: {scope: [:post]}
  validates :post, presence: true
  validates :choice, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  before_save :touch_post_by_vote
end
