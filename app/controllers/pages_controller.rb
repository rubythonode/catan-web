class PagesController < ApplicationController
  def home
    @postables = Post.recent
    @postables = @postables.watched_by(current_user) if user_signed_in?
    @postables = @postables.all.map &:postable
  end
end
