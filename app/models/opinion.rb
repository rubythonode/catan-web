class Opinion < ActiveRecord::Base
  acts_as :post, as: :postable

  def voted_by voter
    votes.where(user: voter).first
  end

  def voted_by? voter
    votes.exists? user: voter
  end

  def agreed_by? voter
    votes.exists? user: voter, choice: 'agree'
  end

  def disagreed_by? voter
    votes.exists? user: voter, choice: 'disagree'
  end
end
