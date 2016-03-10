class TalksController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :issue
  load_and_authorize_resource :talk, through: :issue, shallow: true

  def index
    @talks = @issue.talks
  end

  def create
    set_issue
    @talk.user = current_user
    if @talk.save
      redirect_to @talk
    else
      render 'new'
    end
  end

  def update
    set_issue
    if @talk.update_attributes(talk_params)
      redirect_to @talk
    else
      render 'edit'
    end
  end

  def destroy
    @talk.destroy
    redirect_to issue_home_path(@talk.issue)
  end
  private

  def talk_params
    params.require(:talk).permit(:title, :body)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @talk.issue = @issue
  end
end
