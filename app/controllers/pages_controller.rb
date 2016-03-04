class PagesController < ApplicationController
  before_filter :authenticate_user!, only: :dashboard

  def home
    if user_signed_in?
      redirect_to :dashboard
    else
      redirect_to issue_home_path(Issue::OF_ALL)
    end
  end

  def dashboard
    watched_posts = Post.for_list.recent.watched_by(current_user)
    @watched_posts_for_filter = watched_posts

    @watched_posts = filter_posts(watched_posts)
    @watched_postables = @watched_posts.all.map &:postable
  end
end
