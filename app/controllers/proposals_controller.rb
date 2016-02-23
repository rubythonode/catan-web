class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :discussion
  load_and_authorize_resource :proposal, through: :discussion, shallow: true

  def create
    set_issue
    @proposal.user = current_user
    @proposal.save
    redirect_to @discussion
  end

  def update
    set_issue
    if @proposal.update_attributes(proposal_params)
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @proposal.destroy
    redirect_to @proposal.discussion
  end

  private

  def proposal_params
    params.require(:proposal).permit(:body)
  end

  def set_issue
    @discussion ||= @proposal.discussion
    @proposal.issue = @discussion.issue
  end
end
