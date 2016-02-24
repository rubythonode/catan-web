class UsersController < ApplicationController
  def home
    @user = User.find_by! nickname: params[:nickname].try(:downcase)
    @posts = @user.posts.for_list
    @posts_for_filter = @posts

    if params[:t].present?
      @posts = @posts.by_postable_type(params[:t])
    end
    @postables = @posts.map &:postable
  end
end
