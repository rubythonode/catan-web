class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    watched_posts = Post.for_list.recent.watched_by(current_user)
    @watched_posts_for_filter = watched_posts
    @past_day_postables = @watched_posts_for_filter.past_day.map &:postable

    @watched_posts = filter_posts(watched_posts)
    @watched_postables = @watched_posts.all.map &:postable
  end

  def comments
    @comments = current_user.watched_comments.page params[:page]
  end
end
