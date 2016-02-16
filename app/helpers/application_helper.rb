module ApplicationHelper
  def byline user
    return if user.nil?
    raw render(partial: 'users/byline', locals: { user: user })
  end

  def issue_home_path(issue)
    slug_issue_path(slug: issue.title)
  end
end
