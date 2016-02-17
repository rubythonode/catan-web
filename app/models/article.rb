class Article < ActiveRecord::Base
  acts_as :post, as: :postable
end
