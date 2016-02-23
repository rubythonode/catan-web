class Problem < ActiveRecord::Base
  acts_as :post, as: :postable

  has_many :suggestions do
    def sort_by_agree_count
      sort_by { |e| [e.votes.agreed.count, e.created_at]  }.reverse
    end
  end
end
