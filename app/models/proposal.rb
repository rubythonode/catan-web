class Proposal < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable
  belongs_to :discussion

  validates :discussion, presence: true
  validates :body, presence: true

  def origin
    discussion
  end
end
