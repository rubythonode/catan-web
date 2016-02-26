class PagesController < ApplicationController
  before_filter :authenticate_user!, only: :dashboard
  def dashboard
    watched_posts = Post.for_list.recent.watched_by(current_user)
    @watched_posts_for_filter = watched_posts

    if params[:t].present?
      watched_posts = watched_posts.by_postable_type(params[:t])
    end
    @watched_postables = watched_posts.all.map &:postable
  end
end
