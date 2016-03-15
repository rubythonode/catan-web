class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :post
  load_and_authorize_resource :comment, through: :post, shallow: true

  def create
    set_choice
    @comment.user = current_user
    @comment.save

    redirect_to_origin
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to_origin
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.post.specific
  end

  private

  def redirect_to_origin
    redirect_to @comment.post.specific.origin
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_choice
    if @comment.post.specific.respond_to? :voted_by
      @vote = @comment.post.specific.voted_by current_user
      @comment.choice = @vote.try(:choice)
    end
  end
end
