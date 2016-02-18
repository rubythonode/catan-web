class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  scope :recent, -> { order(created_at: :desc) }
  scope :persisted, -> { where "id IS NOT NULL" }

  validates :user, presence: true
  validates :post, presence: true
end
