class PagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to :dashboard
    else
      redirect_to issue_home_path(Issue::OF_ALL)
    end
  end

  def about
  end
end
