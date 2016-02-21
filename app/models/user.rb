class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  VALID_NICKNAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :nickname,
    presence: true,
    exclusion: { in: %w(app new edit index session login logout users admin all crew issue group) },
    format: { with: VALID_NICKNAME_REGEX },
    uniqueness: { case_sensitive: false },
    length: { maximum: 20 }
  validate :nickname_exclude_pattern

  before_save :downcase_nickname

  has_many :watches
  has_many :watched_issues, through: :watches, source: :issue

  after_create :watch_default_issues
  mount_uploader :image, UserImageUploader

  def admin?
    if Rails.env.staging? or Rails.env.production?
      %w(jennybe0117@gmail.com rest515@parti.xyz berry@parti.xyz royjung@parti.xyz mozo@parti.xyz dalikim@parti.xyz).include? email
    else
      %w(admin@test.com).include? email
    end
  end

  private

  def downcase_nickname
    self.nickname = nickname.downcase
  end

  def watch_default_issues
    issue = Issue.find_by slug: Issue::SLUG_OF_ASK_PARTI
    Watch.create(user: self, issue: issue) if issue.present?
  end

  def nickname_exclude_pattern
    unless self.nickname !~ /\Aparti.*\z/i
      errors.add(:nickname, "predefined")
    end
  end
end
