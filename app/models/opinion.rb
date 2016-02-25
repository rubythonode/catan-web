class Opinion < ActiveRecord::Base
  acts_as :post, as: :postable
  validates :title, presence: true
end
