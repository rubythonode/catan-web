Rails.application.config.to_prepare do
  User.class_eval do
    has_many :watches
    has_many :watched_issues, through: :watches, source: :issue

    after_create :watch_default_issues

    def admin?
      if Rails.env.staging? or Rails.env.production?
        %w(jennybe0117@gmail.com rest515@parti.xyz berry@parti.xyz royjung@parti.xyz mozo@parti.xyz dalikim@parti.xyz).include? email
      else
        %w(admin@test.com).include? email
      end
    end

    private

    def watch_default_issues
      issue = Issue.find_by slug: Issue::SLUG_OF_ASK_PARTI
      Watch.create(user: self, issue: issue) if issue.present?
    end
  end
end
