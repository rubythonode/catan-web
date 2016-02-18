class PagesController < ApplicationController
  def home
    @postables = Post.recent.all.map &:postable
  end
end
