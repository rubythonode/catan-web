class Answer < ActiveRecord::Base
  acts_as :post, as: :postable
  belongs_to :question

  def origin_post
    question
  end
end
