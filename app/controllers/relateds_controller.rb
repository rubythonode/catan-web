class RelatedsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    if params[:issue_id].present?
      @issue = Issue.find params[:issue_id]
      @related = @issue.relateds.build
    else
      redirect_to root_path
    end
  end

  def create
    @related.target = Issue.find_by title: params[:target_title]
    redirect_to @related.issue and return unless @related.target.present?

    if @related.save
      redirect_to @related.issue
    else
      render 'new'
    end
  end

  def destroy
    @related.destroy
    redirect_to issue_home_path(@related.issue)
  end

  private

  def create_params
    params.require(:related).permit(:issue_id)
  end
end
