class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  validates :issue_id, presence: true
end