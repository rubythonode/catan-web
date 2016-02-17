class PagesController < ApplicationController
  def home
    @postables = Post.all.map &:postable
  end
end
