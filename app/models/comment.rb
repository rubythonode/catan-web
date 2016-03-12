class Comment < ActiveRecord::Base
  acts_as_paranoid
  include Choosable

  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, presence: true
  validates :post, presence: true
  validates :body, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :persisted, -> { where "id IS NOT NULL" }
end
