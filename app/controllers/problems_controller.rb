class ProblemsController < ApplicationController
  before_filter :authenticate_user!, except: :show
  load_and_authorize_resource

  def new
    if params[:issue_id].present?
      @issue = Issue.find params[:issue_id]
      @problem.issue = @issue
    end
  end

  def create
    set_issue
    @problem.user = current_user
    if @problem.save
      redirect_to @problem
    else
      render 'new'
    end
  end

  def update
    set_issue
    if @problem.update_attributes(problem_params)
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destroy
    @problem.destroy
    redirect_to issue_home_path(@problem.issue)
  end

  def show
    prepare_meta_tags title: @problem.title,
                      description: @problem.body
  end

  private

  def problem_params
    params.require(:problem).permit(:title, :body, :tag_list)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @problem.issue = @issue
  end
end
