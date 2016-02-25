class Related < ActiveRecord::Base
  belongs_to :issue
  belongs_to :target, class_name: Issue

  validates :issue, presence: true
  validates :target, presence: true
end
