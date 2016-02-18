class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :user, presence: true
  validates :post, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :persisted, -> { where "id IS NOT NULL" }

  before_create :touch_post

  private

  def touch_post
    post.touch(:touched_at)
  end
end
