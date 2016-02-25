class Answer < ActiveRecord::Base
  acts_as :post, as: :postable
  belongs_to :question
  validates :question, presence: true
  validates :body, presence: true

  def origin_post
    question
  end
end
