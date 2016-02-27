class TagsController < ApplicationController
  def show
    prepare_meta_tags title: params[:name],
                      description: params[:name]
    @posts = Post.recent.tagged_with(params[:name])
    @posts_for_filter = @posts
    @posts = filter_posts(@posts)
    @postables = @posts.map &:postable
  end
end
