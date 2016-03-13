class TransfersController < ApplicationController
  layout 'transfers'

  def start
    sign_out
  end

  def confirm
    @email_user = User.find_by email: params[:email], provider: 'email'
    if !@email_user.present? or !@email_user.valid_password?(params[:password])
      flash[:warning] = '이메일과 비밀번호가 정확한지 확인해 주세요'
      redirect_to start_transfers_path and return
    elsif !@email_user.active_for_authentication?
      flash[:warning] = '확인되지 않은 회원입니다.'
      redirect_to start_transfers_path and return
    end
    sign_in(@email_user, event: :authentication)
    @email_user = current_user
  end
end
