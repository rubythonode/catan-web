class LikesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :post
  load_and_authorize_resource :like, through: :post, shallow: true

  def create
    @like.user = current_user
    @like.save

    respond_to do |format|
      format.js
    end
  end

  def cancel
    @like = @post.likes.find_by user: current_user
    @like.destroy

    respond_to do |format|
      format.js
    end
  end

  def by_me
    @posts = Post.joins(:likes).where('likes.user': current_user)
    @posts_for_filter = @posts
    if params[:t].present?
      @posts = @posts.by_postable_type(params[:t])
    end
    @postable = @posts.map(&:postable)
  end
end
