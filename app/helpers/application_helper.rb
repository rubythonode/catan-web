module ApplicationHelper
  def byline(user, options={})
    return if user.nil?
    raw render(partial: 'users/byline', locals: options.merge(user: user))
  end

  def issue_home_path(issue)
    slug_issue_path(slug: issue.title)
  end

  def choice_icon(subject)
    choice_value = subject
    choice_value = subject.choice if subject.respond_to?(:choice)
    return if choice_value.nil?
    case choice_value.to_sym
    when :agree
      fa_icon('thumbs-up')
    when :disagree
      fa_icon('thumbs-down')
    end
  end

  def fa_icon(name)
    content_tag(:i, nil, class: "fa fa-#{name}")
  end

  def date_f(date)
    if date.today?
      date.strftime("%H:%M")
    else
      date.strftime("%Y.%m.%d")
    end
  end
end
