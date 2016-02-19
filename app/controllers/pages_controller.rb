class PagesController < ApplicationController
  def home
    @postables = Post.recent
    @postables = @postables.watched_by(current_user) if user_signed_in?

    if params[:t].present?
      @postables = @postables.by_postable_type(params[:t])
    end
    @postables = @postables.all.map &:postable
  end
end
