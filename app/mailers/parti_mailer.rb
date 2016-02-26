class PartiMailer < ApplicationMailer
  def summary(user)
    @user = user
    @posts = @user.watched_posts.for_list.yesterday(field: :touched_at)
    mail(to: @user.email, subject: "#{I18n.l Date.yesterday} Parti 유쾌한 민주주의 소식입니다!")
  end
end
