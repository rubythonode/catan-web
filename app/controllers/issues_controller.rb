class IssuesController < ApplicationController
  def index
    @issues = Issue.all
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