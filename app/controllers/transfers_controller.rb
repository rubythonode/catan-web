class TransfersController < ApplicationController
  layout 'transfers'
  before_filter :omniauthed!, except: :step1

  def step1
    sign_out
  end

  def step3
    prepare_meta_tags
    @email_user = User.find_by email: params[:email], provider: 'email'
    if !@email_user.present? or !@email_user.valid_password?(params[:password])
      flash[:warning] = '이메일과 비밀번호가 정확한지 확인해 주세요'
      redirect_to step2_transfers_path
    end
  end

  def step4
    prepare_meta_tags
    @email_user = User.find_by email: params[:email], provider: 'email'
    if !@email_user.present? or !@email_user.valid_password?(params[:password])
      flash[:warning] = '이메일과 비밀번호가 정확한지 확인해 주세요'
      redirect_to step2_transfers_path
    end

    ActiveRecord::Base.transaction do
      [Post, Comment].each do |model|
        entities = model.where(user: @email_user)
        entities.each do |entity|
          entity.update_columns(user_id: current_user)
        end
      end
      likes = Like.where(user: @email_user)
      likes.each do |like|
        if like.post.present? and !like.post.liked_by? current_user
          like.update_columns(user_id: current_user)
        else
          like.destroy!
        end
      end
      votes = Vote.where(user: @email_user)
      votes.each do |vote|
        if vote.post.present? and !vote.post.voted_by? current_user
          vote.update_columns(user_id: current_user)
        else
          vote.destroy!
        end
      end
      watches = Watch.where(user: @email_user)
      watches.each do |watch|
        if watch.issue.present? and !watch.issue.watched_by? current_user
          watch.update_columns(user_id: current_user)
        else
          watch.destroy!
        end
      end
      @email_user.destroy!
    end
  end

  private

  def omniauthed!
    if !user_signed_in? or current_user.provider == 'email'
      redirect_to step1_transfers_path
    end
  end
end
