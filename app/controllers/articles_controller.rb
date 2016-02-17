class ArticlesController < ApplicationController
  before_filter :authenticate_user!, except: :show
  load_and_authorize_resource

  def new
    if params[:issue_id].present?
      @issue = Issue.find params[:issue_id]
      @article.issue = @issue
    end
  end

  def create
    set_issue
    @article.user = current_user
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    set_issue
    if @article.update_attributes(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :link)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @article.issue = @issue
  end
end
