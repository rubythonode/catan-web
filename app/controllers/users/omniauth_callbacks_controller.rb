class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
    end

    run_omniauth
  end

  def google_oauth2
    run_omniauth
  end

  def twitter
    run_omniauth
  end

  def run_omniauth
    parsed_data = User.parse_omniauth(request.env["omniauth.auth"])
    @user = User.find_for_omniauth(parsed_data)

    if @user.present?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => @user.provider) if is_navigational_format?
    else
      session["devise.omniauth_data"] = parsed_data
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
