class TagsController < ApplicationController
  def show
    @postables = Post.tagged_with(params[:name]).map &:postable
  end
end
