class UsersController < ApplicationController
  def index
    @users = User.order("id DESC")
  end

  def home
    @user = User.find_by! nickname: params[:nickname].try(:downcase)
    @posts = @user.posts.for_list.recent
    @posts_for_filter = @posts
    @posts = filter_posts(@posts)
    @postables = @posts.map &:postable
  end
end
