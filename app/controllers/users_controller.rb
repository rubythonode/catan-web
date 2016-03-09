class UsersController < ApplicationController
  def index
    @users = User.order("id DESC")
  end

  def gallery
    @user = User.find_by! nickname: params[:nickname].try(:downcase)
    @posts = @user.posts.for_list
    @posts_for_filter = @posts
    @posts = filter_posts(@posts)
    @postables = @posts.map &:postable
  end

  def summary_test
    User.limit(100).each do |user|
      PartiMailer.summary_by_mailtrap(user).deliver_later
    end
    render text: 'ok'
  end
end
