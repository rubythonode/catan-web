class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  VALID_NICKNAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :nickname,
    presence: true,
    exclusion: { in: %w(app new edit index session login logout users admin all crew issue group) },
    format: { with: VALID_NICKNAME_REGEX },
    uniqueness: { case_sensitive: false },
    length: { maximum: 20 }
  validate :nickname_exclude_pattern
  validates :email,
    presence: true,
    format: { with: Devise.email_regexp }

  validates :uid, uniqueness: {scope: [:provider]}

  validates :password,
    presence: true,
    confirmation: true,
    length: Devise.password_length,
    if: :password_required?

  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true

  before_save :downcase_nickname
  before_save :set_uid

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

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.parse_omniauth(data)
    {provider: data['provider'], uid: data['uid'], email: data['info']['email'], image: data['info']['image']}
  end

  def self.find_for_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["provider = 'email' AND uid = :value", { :value => email.downcase }]).first
  end

  def self.new_with_session(params, session)
    resource = super
    auth = session["devise.omniauth_data"]
    if auth.present?
      resource.assign_attributes(auth)
      resource.password = Devise.friendly_token[0,20]
      resource.confirmed_at = DateTime.now
      resource.remote_image_url = auth['image']
    else
      resource.provider = 'email'
    end
    resource
  end

  private

  def downcase_nickname
    self.nickname = nickname.downcase
  end

  def set_uid
    self.uid = self.email if self.provider == 'email'
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

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
