class TagsController < ApplicationController
  def show
    @postables = Post.recent.tagged_with(params[:name]).map &:postable
  end
end
