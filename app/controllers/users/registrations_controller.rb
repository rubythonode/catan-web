class Users::RegistrationsController < Devise::RegistrationsController
  include AfterLogin
  after_filter :after_omniauth_login, only: :create

  private

  def sign_up_params
    params.require(:user).permit(:nickname, :image, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:nickname, :image, :email, :password, :password_confirmation, :current_password)
  end

  def after_inactive_sign_up_path_for(resource)
    welcome_path
  end
end
