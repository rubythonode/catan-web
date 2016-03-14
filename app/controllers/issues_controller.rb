class IssuesController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_user!, except: [:show, :index, :slug, :users, :exist]
  load_and_authorize_resource

  def index
    prepare_meta_tags title: "이슈", description: "모든 이슈들입니다."
    @issues = Issue.all
    if request.format.json?
      @issues = @issues.limit(10)
    else
      @issue_of_all = Issue::OF_ALL
    end

    if params[:query].present?
      @issues = @issues.where("title like ?", "%#{params[:query]}%" )
    end
    respond_with @issues
  end

  def show
    @issue = Issue.find params[:id]
    redirect_to slug_issue_path(slug: @issue.slug)
  end

  def slug
    @issue = Issue.find_by slug: params[:slug]
    @issue = Issue::OF_ALL if params[:slug] == 'all'
    if @issue.blank?
      @issue_by_title = Issue.find_by(title: params[:slug].titleize)
      if @issue_by_title.present?
        redirect_to @issue_by_title and return
      else
        render_404 and return
      end
    end
    @posts = @issue.posts.for_list

    unless view_context.current_page?(root_url)
      prepare_meta_tags title: @issue.title,
                        description: @issue.body,
                        image: @issue.cover_url
    end

    @posts_for_filter = @posts
    @past_day_postables = @posts.recent.past_day.map &:postable
    @posts = filter_posts(@posts)
    @postables = @posts.map &:postable
    render template: 'issues/show'
  end

  def slug_comments
    @issue = Issue.find_by slug: params[:slug]
    @issue = Issue::OF_ALL if params[:slug] == 'all'
    if @issue.blank?
      @issue_by_title = Issue.find_by(title: params[:slug].titleize)
      if @issue_by_title.present?
        redirect_to @issue_by_title and return
      else
        render_404 and return
      end
    end
    @comments = @issue.comments.page params[:page]
    @posts = @issue.posts
    unless view_context.current_page?(root_url)
      prepare_meta_tags title: @issue.title,
                        description: @issue.body,
                        image: @issue.cover_url
    end
  end

  def slug_campaign
    if params[:slug] == 'all'
      @issue = Issue::OF_ALL
      @posts = Post.for_list
    else
      @issue = Issue.find_by slug: params[:slug]
      if @issue.blank?
        @issue_by_title = Issue.find_by(title: params[:slug].titleize)
        if @issue_by_title.present?
          redirect_to @issue_by_title and return
        else
          render_404 and return
        end
      end
      @posts = @issue.posts.for_list
    end
  end

  def create
    if !%w(all).include?(@issue.slug) and @issue.save
      redirect_to @issue
    else
      render 'new'
    end
  end

  def update
    @issue.assign_attributes(issue_params)
    if @issue.save
      redirect_to @issue
    else
      render 'edit'
    end
  end

  def destroy
    @issue.destroy
    redirect_to root_path
  end

  def users

  end

  def exist
    respond_to do |format|
      format.json { render json: Issue.exists?(title: params[:title]) }
    end
  end

  helper_method :fetch_issue
  def fetch_issue
    @issue
  end
  private

  def issue_params
    params.require(:issue).permit(:title, :body, :logo, :cover, :slug)
  end
end
