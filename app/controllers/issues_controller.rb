class IssuesController < ApplicationController
  respond_to :json, :html

  def index
    @issues = Issue.limit(10)
    if params[:query].present?
      @issues = @issues.where("title like ?", "%#{params[:query]}%" )
    end
    respond_with @issues
  end

  def show
    @issue = Issue.find params[:id]
    redirect_to slug_issue_path(slug: @issue.title)
  end

  def slug
    @issue = Issue.find_by! title: params[:slug]
    @articles = @issue.articles
    render template: 'issues/show'
  end
end