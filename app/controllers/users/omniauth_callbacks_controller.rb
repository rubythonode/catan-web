class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include AfterLogin
  prepend_before_filter :require_no_authentication, only: [:facebook, :google_oauth2, :twitter]
  before_filter :authenticate_user!, only: [:facebook_transfer, :google_oauth2_transfer]

  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email" and return
    end

    run_omniauth
  end

  def google_oauth2
    run_omniauth
  end

  def twitter
    run_omniauth
  end


  def failure
    redirect_to root_path
  end

  def facebook_transfer
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email" and return
    end

    transfer
  end

  def google_oauth2_transfer
    transfer
  end

  private

  def run_omniauth
    parsed_data = User.parse_omniauth(request.env["omniauth.auth"])
    remember_me = request.env["omniauth.params"].try(:fetch, "remember_me", false)
    parsed_data[:remember_me] = remember_me
    @user = User.find_for_omniauth(parsed_data)
    if @user.present?
      @user.remember_me = remember_me
      sign_in_and_redirect @user, :event => :authentication
      after_omniauth_login
      set_flash_message(:notice, :success, :kind => @user.provider) if is_navigational_format?
    else
      session["devise.omniauth_data"] = parsed_data
      session["omniauth.params_data"] = request.env["omniauth.params"]
      redirect_to new_user_registration_url
    end
  end

  def transfer
    failure and return if current_user.try(:provider) != 'email'

    parsed_data = User.parse_omniauth(request.env["omniauth.auth"])
    remember_me = request.env["omniauth.params"].try(:fetch, "remember_me", false)
    parsed_data[:remember_me] = remember_me
    @omniauth_user = User.find_for_omniauth(parsed_data)
    @email_user = current_user

    logger.info "Trasnfer : Start"
    logger.info "Email User : #{@email_user.nickname}"
    ActiveRecord::Base.transaction do
      if @omniauth_user.present?
        logger.info "Omniauth User : #{@omniauth_user.nickname}"
        transfer_data
        @omniauth_user.remember_me = remember_me
        sign_out
        sign_in(@omniauth_user, :event => :authentication)
      else
        logger.info "Omniauth User : None"
        @email_user.remember_me = remember_me
        @email_user.assign_attributes(parsed_data.except(:email, :image))
        @email_user.save
        sign_out
        sign_in(@email_user, :event => :authentication)
      end
    end
    logger.info "Trasnfer : End"
    redirect_to final_transfers_path
  end

  def transfer_data

    [Post, Comment].each do |model|
      entities = model.where(user: @email_user)
      entities.each do |entity|
        entity.update_columns(user_id: @omniauth_user)
      end
    end
    likes = Like.where(user: @email_user)
    likes.each do |like|
      if like.post.present? and !like.post.liked_by? @omniauth_user
        like.update_columns(user_id: @omniauth_user)
      else
        like.destroy!
      end
    end
    votes = Vote.where(user: @email_user)
    votes.each do |vote|
      if vote.post.present? and !vote.post.voted_by? @omniauth_user
        vote.update_columns(user_id: @omniauth_user)
      else
        vote.destroy!
      end
    end
    watches = Watch.where(user: @email_user)
    watches.each do |watch|
      if watch.issue.present? and !watch.issue.watched_by? @omniauth_user
        watch.update_columns(user_id: @omniauth_user)
      else
        watch.destroy!
      end
    end
    @email_user.destroy!
  end
end
