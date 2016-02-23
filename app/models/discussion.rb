class Discussion < ActiveRecord::Base
  acts_as :post, as: :postable

  has_many :proposals do
    def sort_by_agree_count
      sort_by { |p| [p.votes.agreed.count, p.created_at] }.reverse
    end
  end
end
