class Post < ActiveRecord::Base
  actable as: :postable

  belongs_to :issue
  belongs_to :user
  has_many :comments

  validates :user, presence: true
  validates :issue, presence: true

  default_scope -> { joins(:issue) }
end
