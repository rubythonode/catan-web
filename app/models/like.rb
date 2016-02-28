class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user, presence: true
  validates :post, presence: true
  validates :user, uniqueness: {scope: [:post]}

  scope :recent, -> { order(created_at: :desc) }
end
