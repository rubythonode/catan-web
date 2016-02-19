class TagsController < ApplicationController
  def show
    @posts = Post.recent.tagged_with(params[:name])
    if params[:t].present?
      @posts = @posts.by_postable_type(params[:t])
    end
    @postables = @posts.map &:postable
  end
end
