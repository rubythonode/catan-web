class ArticlesController < ApplicationController
  include OriginPostable
  before_filter :authenticate_user!, except: [:show, :matched]
  load_and_authorize_resource except: :matched

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

  def destroy
    @article.destroy
    redirect_to issue_home_path(@article.issue)
  end

  def show
    prepare_meta_tags title: @article.body
  end

  def matched_link
    @matched_articles = Article.where(link: params[:link]).recent.limit(3) unless params[:link].blank?
    render layout: nil
  end

  helper_method :fetch_issue
  def fetch_issue
    @issue ||= @article.try(:issue)
  end

  def postable_controller?
    true
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :link, :tag_list)
  end

  def set_issue
    @issue ||= Issue.find_by title: params[:issue_title]
    @article.issue = @issue
  end
end
