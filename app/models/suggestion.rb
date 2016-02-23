class Suggestion < ActiveRecord::Base
  acts_as :post, as: :postable
  belongs_to :problem

  def origin_post
    problem
  end
end
