class AnswersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question, shallow: true

  def create
    set_issue
    @answer.user = current_user
    @answer.save
    redirect_to @question
  end

  def update
    set_issue
    if @answer.update_attributes(answer_params)
      redirect_to @question
    else
      render 'edit'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_issue
    @question ||= @answer.question
    @answer.issue = @question.issue
  end
end
