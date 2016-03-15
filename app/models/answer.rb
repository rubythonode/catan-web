class Answer < ActiveRecord::Base
  acts_as_paranoid
  acts_as :post, as: :postable
  belongs_to :question
  validates :question, presence: true
  validates :body, presence: true

  def origin
    question
  end
end
