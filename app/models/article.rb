class Article < ActiveRecord::Base
  acts_as :post, as: :postable
  validates :title, presence: true
  validates :body, presence: true
end
