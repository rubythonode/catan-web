class TagsController < ApplicationController
  def show
    prepare_meta_tags title: params[:name],
                      description: params[:name]
    @posts = Post.recent.tagged_with(params[:name])
    @posts_for_filter = @posts
    if params[:t].present?
      @posts = @posts.by_postable_type(params[:t])
    end
    @postables = @posts.map &:postable
  end
end
