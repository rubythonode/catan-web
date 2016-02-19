class VotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :post
  load_and_authorize_resource :vote, through: :post, shallow: true

  def create
    @poinion = @post.specific
    previous_vote = @poinion.voted_by current_user
    if previous_vote.present?
      @vote = previous_vote
      @vote.choice = params[:vote][:choice]
    else
      @vote.user = current_user
    end

    @vote.save
    redirect_to @poinion
  end

  private

  def vote_params
    params.require(:vote).permit(:choice)
  end
end
