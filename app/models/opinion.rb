class Opinion < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable
  validates :title, presence: true, length: { maximum: 50 }
  scope :latest, -> { after(1.day.ago) }
end
