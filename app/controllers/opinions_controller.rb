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
    set_issue
    @opinion.user = current_user
    if @opinion.save
      set_comment
      set_vote
      redirect_to @opinion
    else
      render 'new'
    end
  end

  def update
    set_issue
    if @opinion.update_attributes(update_params)
      redirect_to @opinion
    else
      render 'edit'
    end
  end

  def destroy
    @opinion.destroy
    redirect_to issue_home_path(@opinion.issue)
  end

  private

  def set_comment
    body = params[:body]
    if body.present?
      @comment = @opinion.post.comments.create(user: current_user, body: body, choice: :agree)
    end
  end

  def set_vote
    @vote = @opinion.post.votes.create(user: current_user, choice: :agree)
  end

  def create_params
    params.require(:opinion).permit(:title, :body, :tag_list)
  end

  def update_params
    params.require(:opinion).permit(:title, :tag_list)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @opinion.issue = @issue
  end
end
