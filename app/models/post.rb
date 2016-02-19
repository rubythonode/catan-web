class Post < ActiveRecord::Base
  actable as: :postable
  acts_as_taggable

  belongs_to :issue
  belongs_to :user
  has_many :comments
  has_many :likes, counter_cache: true

  validates :user, presence: true
  validates :issue, presence: true

  default_scope -> { joins(:issue) }
  scope :recent, -> { order(touched_at: :desc) }
  scope :watched_by, ->(someone) { where(issue_id: someone.watched_issues) }
  scope :by_postable_type, ->(t) { where(postable_type: t.camelize) }

  before_save :update_touched_at

  def liked_by? someone
    likes.exists? user: someone
  end

  private

  def update_touched_at
    self.touched_at = DateTime.now
  end
end
