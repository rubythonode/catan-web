class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end
  def show
    @issue = Issue.find params[:id]
    @articles = @issue.articles
  end
end