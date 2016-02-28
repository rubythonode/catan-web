class PartiMailer < ApplicationMailer
  def summary(user)
    @user = user
    @created_posts = @user.watched_posts.for_list.yesterday
    @hottest_posts = @user.watched_posts.for_list.yesterday_hottest - @created_posts
    mail(to: @user.email, subject: "#{I18n.l Date.yesterday} Parti 유쾌한 민주주의 소식입니다!")
  end
end
