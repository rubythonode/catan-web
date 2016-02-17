class Post < ActiveRecord::Base
  actable as: :postable

  belongs_to :issue
  belongs_to :user

  validates :user, presence: true
  validates :issue, presence: true
end
