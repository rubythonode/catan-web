class Proposal < ActiveRecord::Base
  acts_as :post, as: :postable
  belongs_to :discussion

  def origin_post
    discussion
  end
end
