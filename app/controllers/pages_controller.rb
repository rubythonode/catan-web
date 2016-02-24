class PagesController < ApplicationController
  def dashboard
    watched_posts = Post.for_list.recent.watched_by(current_user)
    @watched_posts_for_filter = watched_posts

    if params[:t].present?
      watched_posts = watched_posts.by_postable_type(params[:t])
    end
    @watched_postables = watched_posts.all.map &:postable
  end

  def basic_income
    redirect_to slug_issue_path('기본소득')
  end

  def filibuster
    redirect_to slug_issue_path('테러방지법-필리버스터')
  end
end
