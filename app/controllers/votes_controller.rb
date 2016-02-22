class VotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :post
  load_and_authorize_resource :vote, through: :post, shallow: true

  def create
    @specific = @post.specific
    previous_vote = @specific.voted_by current_user
    if previous_vote.present?
      @vote = previous_vote
      @vote.choice = params[:vote][:choice]
    else
      @vote.user = current_user
    end

    @vote.save
    redirect_to_origin_post
  end

  private

  def vote_params
    params.require(:vote).permit(:choice)
  end

  def redirect_to_origin_post
    if @vote.post.specific.respond_to? :origin_post
      redirect_to @vote.post.specific.origin_post
    else
      redirect_to @vote.post.specific
    end
  end
end
