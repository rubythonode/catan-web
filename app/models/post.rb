class Post < ActiveRecord::Base
  actable as: :postable
  acts_as_taggable

  belongs_to :issue
  belongs_to :user
  has_many :comments


  validates :user, presence: true
  validates :issue, presence: true

  default_scope -> { joins(:issue) }
  scope :recent, -> { order(touched_at: :desc) }

  before_save :update_touched_at

  private

  def update_touched_at
    self.touched_at = DateTime.now
  end
end
