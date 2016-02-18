class VotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :opinion
  load_and_authorize_resource :vote, through: :opinion, shallow: true

  def create
    previous_vote = @opinion.voted_by current_user
    if previous_vote.present?
      @vote = previous_vote
      @vote.choice = params[:vote][:choice]
    else
      @vote.user = current_user
    end

    @vote.save
    redirect_to @opinion
  end

  private

  def vote_params
    params.require(:vote).permit(:choice)
  end
end
