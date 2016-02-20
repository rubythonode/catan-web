class PagesController < ApplicationController
  def home
    all_post = Post.recent
    if params[:t].present?
      all_post = all_post.by_postable_type(params[:t])
    end

    @all_postables = all_post.all.map &:postable
    if user_signed_in?
      @watched_postables = all_post.watched_by(current_user).all.map &:postable
    end
  end

  def basic_income
    redirect_to slug_issue_path('기본소득')
  end
end
