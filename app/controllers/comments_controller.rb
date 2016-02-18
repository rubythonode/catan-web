class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :post
  load_and_authorize_resource :comment, through: :post, shallow: true

  def create
    @comment.user = current_user
    @comment.save
    redirect_to @comment.post.specific
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to @comment.post.specific
    else
      render 'edit'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
