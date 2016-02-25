class Proposal < ActiveRecord::Base
  acts_as :post, as: :postable
  belongs_to :discussion

  validates :discussion, presence: true
  validates :body, presence: true

  def origin_post
    discussion
  end
end
