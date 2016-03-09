class Opinion < ActiveRecord::Base
  acts_as :post, as: :postable
  validates :title, presence: true
  scope :latest, -> { after(1.day.ago) }
end
