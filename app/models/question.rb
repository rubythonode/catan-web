class Question < ActiveRecord::Base
  acts_as :post, as: :postable

  has_many :answers do
    def sort_by_vote_point
      sort { |a, b| b.votes.point <=> a.votes.point }
    end
  end
end
