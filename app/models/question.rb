class Question < ActiveRecord::Base
  acts_as :post, as: :postable

  has_many :answers do
    def sort_by_vote_point
      sort_by { |e| [e.votes.point, e.created_at]  }.reverse
    end
  end
end
