class Issue < ActiveRecord::Base
  TITLE_OF_ASK_PARTI = 'Ask Parti'
  SLUG_OF_ASK_PARTI = 'ask-parti'
  # OF_ALL = RecursiveOpenStruct.new({
  #   is_all?: true, title: '모든 이슈',
  #   slug: 'all',
  #   posts: Post.all,
  #   articles: Article.all,
  #   opinions: Opinion.all,
  #   watches: User.all})
  OF_ALL = Naught.build do |config|
    config.singleton
    config.impersonate Issue
    def is_all?
      true
    end
    def title
      '모든 이슈'
    end
    def slug
      'all'
    end
    def posts
      Post.all
    end
    def recommends
      (Issue.past_week + Issue.hottest.limit(10)).uniq.shuffle
    end
  end.instance

  def OF_ALL.logo_url
    ActionController::Base.helpers.asset_path('all_issue_logo.png')
  end
  def OF_ALL.cover_url
    ActionController::Base.helpers.asset_path('default_issue_cover.png')
  end

  # relations
  has_many :relateds
  has_many :related_issues, through: :relateds, source: :target
  has_many :posts do
    def latest
      after(1.day.ago)
    end
  end
  has_many :articles, through: :posts, source: :postable, source_type: Article
  has_many :opinions, through: :posts, source: :postable, source_type: Opinion
  has_many :questions, through: :posts, source: :postable, source_type: Question
  has_many :discussions, through: :posts, source: :postable, source_type: Discussion
  has_many :watches do
    def latest
      after(1.day.ago)
    end
  end

  # validations
  validates :title, presence: true
  VALID_SLUG = /\A[a-z0-9_-]+\z/i
  validates :slug,
    presence: true,
    format: { with: VALID_SLUG },
    exclusion: { in: %w(app new edit index session login logout users admin
    stylesheets assets javascripts images) },
    uniqueness: { case_sensitive: false },
    length: { maximum: 100 }

  # fields
  mount_uploader :logo, ImageUploader
  mount_uploader :cover, ImageUploader

  # callbacks
  before_save :downcase_slug

  # scopes
  scope :hottest, -> { order('issues.watches_count + issues.posts_count desc') }

  # methods
  def watched_by? someone
    watches.exists? user: someone
  end

  def is_all?
    false
  end

  def slug_formated_title
    return if self.title.blank?
    self.slug = self.title.strip.downcase.gsub(/\s+/, "-")
  end

  # deprecated
  def contributors
    commiters
  end

  def commiters
    (posts.map(&:user) + watches.map(&:user)).compact.uniq
  end

  def related_with? something
    relateds.exists?(target: something)
  end

  def past_week?
    created_at > 1.week.ago
  end

  def recommends
    (related_issues + OF_ALL.recommends - [self]).uniq.shuffle
  end

  private

  def downcase_slug
    return if slug.blank?
    self.slug = slug.downcase
  end
end
