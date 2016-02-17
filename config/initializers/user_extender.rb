Rails.application.config.to_prepare do
  User.class_eval do
    def admin?
      if Rails.env.staging?
        %w(rest515@parti.xyz berry@parti.xyz royjung@parti.xyz mozo@parti.xyz dalikim@parti.xyz).include? email
      else
        %w(admin@test.com dali@gmail.com).include? email
      end
    end
  end
end
