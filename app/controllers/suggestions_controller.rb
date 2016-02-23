class SuggestionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :problem
  load_and_authorize_resource :suggestion, through: :problem, shallow: true

  def create
    set_issue
    @suggestion.user = current_user
    @suggestion.save
    redirect_to @problem
  end

  def update
    set_issue
    if @suggestion.update_attributes(suggestion_params)
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to @suggestion.problem
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:body)
  end

  def set_issue
    @problem ||= @suggestion.problem
    @suggestion.issue = @problem.issue
  end
end
