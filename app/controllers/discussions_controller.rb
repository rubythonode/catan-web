class DiscussionsController < ApplicationController
  include OriginPostable
  before_filter :authenticate_user!, except: :show
  load_and_authorize_resource

  def new
    if params[:issue_id].present?
      @issue = Issue.find params[:issue_id]
      @discussion.issue = @issue
    end
  end

  def create
    set_issue
    @discussion.user = current_user
    if @discussion.save
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    set_issue
    if @discussion.update_attributes(discussion_params)
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @discussion.destroy
    redirect_to issue_home_path(@discussion.issue)
  end

  def show
    prepare_meta_tags title: @discussion.title,
                      description: @discussion.body
  end

  helper_method :current_issue
  def current_issue
    @issue ||= @discussion.try(:issue)
  end
  private

  def discussion_params
    params.require(:discussion).permit(:title, :body, :tag_list)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @discussion.issue = @issue
  end
end
