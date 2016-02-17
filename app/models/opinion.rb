class Opinion < ActiveRecord::Base
  acts_as :post, as: :postable
end
