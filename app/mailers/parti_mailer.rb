class PartiMailer < ApplicationMailer
  def summary(user)
    delivery_options = { user_name: ENV['MAILTRAP_USER_NAME'],
                         password: ENV['MAILTRAP_PASSWORD'],
                         address: 'mailtrap.io',
                         domain: 'mailtrap.io',
                         port: '2525',
                         authentication: :cram_md5 } unless Rails.env.test?
    @user = user
    @created_posts = @user.watched_posts.for_list.yesterday.limit(10)
    @hottest_posts = @user.watched_posts.for_list.yesterday_hottest.limit(10) - @created_posts

    if @created_posts.any? or @hottest_posts.any?
      mail(to: @user.email,
        subject: "#{I18n.l Date.yesterday} Parti 유쾌한 민주주의 소식입니다!",
        delivery_method: (:smtp unless Rails.env.test?),
        delivery_method_options: delivery_options || nil)
    end
  end
end
