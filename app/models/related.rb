class Related < ActiveRecord::Base
  belongs_to :issue
  belongs_to :target, class_name: Issue
end
