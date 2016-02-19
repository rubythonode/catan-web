module ApplicationHelper
  def byline(user, options={})
    return if user.nil?
    raw render(partial: 'users/byline', locals: options.merge(user: user))
  end

  def issue_home_path(issue)
    slug_issue_path(slug: issue.title)
  end
end
