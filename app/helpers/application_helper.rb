module ApplicationHelper
  def byline user
    return if user.nil?
    raw render(partial: 'users/byline', locals: { user: user })
  end
end
