class PagesController < ApplicationController
  before_filter :authenticate_user!, only: :dashboard
  def dashboard
    watched_posts = Post.for_list.recent.watched_by(current_user)
    @watched_posts_for_filter = watched_posts

    watched_posts = filter_posts(watched_posts)
    @watched_postables = watched_posts.all.map &:postable
  end
end
