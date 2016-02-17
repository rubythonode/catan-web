class OpinionsController < ApplicationController
  before_filter :authenticate_user!, except: :show
  load_and_authorize_resource

  def new
    if params[:issue_id].present?
      @issue = Issue.find params[:issue_id]
      @opinion.issue = @issue
    end
  end

  def create
    @opinion.user = current_user
    if @opinion.save
      redirect_to @opinion
    else
      render 'new'
    end
  end

  def update
    @opinion.assign_attributes(opinion_params)
    if @opinion.save
      redirect_to @opinion
    else
      render 'edit'
    end
  end

  private

  def opinion_params
    params.require(:opinion).permit(:title, :body, :issue_id)
  end
end