class Post < ActiveRecord::Base
  HOT_LIKES_COUNT = 3

  actable as: :postable
  acts_as_taggable
  paginates_per 20

  belongs_to :issue, counter_cache: true
  belongs_to :user
  has_many :comments
  has_many :votes do
    def partial_included_with(someone)
      partial = recent.limit(10)
      if !partial.map(&:user).include?(someone)
        (partial.all << find_by(user: someone)).compact
      else
        partial.all
      end
    end

    def point
      agreed.count - disagreed.count
    end
  end
  has_many :likes, counter_cache: true

  # validations
  validates :issue, presence: true
  validates :user, presence: true

  default_scope -> { joins(:issue) }
  scope :recent, -> { order(created_at: :desc) }
  scope :hottest, -> {
    select('posts.*, COUNT(likes.id) likes_count')
      .joins(:likes)
      .group('posts.id')
      .past_week(field: 'likes.created_at')
      .order('likes_count DESC') }
  scope :yesterday_hottest, -> {
    select('posts.*, COUNT(likes.id) likes_count')
      .joins(:likes)
      .group('posts.id')
      .yesterday(field: 'likes.created_at')
      .having("likes_count > #{HOT_LIKES_COUNT}")
      .order('likes_count DESC') }
  scope :watched_by, ->(someone) { where(issue_id: someone.watched_issues) }
  scope :by_postable_type, ->(t) { where(postable_type: t.camelize) }
  scope :by_filter, ->(f, someone=nil) {
    case f.to_sym
    when :hottest
      hottest
    when :best
      reorder(likes_count: :desc).recent
    when :like
      only_like_by(someone).recent
    when :recent
      recent
    end
  }
  scope :only_articles, -> { by_postable_type(Article.to_s) }
  scope :only_opinions, -> { by_postable_type(Opinion.to_s) }
  scope :only_questions, -> { by_postable_type(Question.to_s) }
  scope :only_discussions, -> { by_postable_type(Discussion.to_s) }
  scope :only_like_by, ->(someone) { joins(:likes).where('likes.user': someone) }
  scope :for_list, -> { where.not(postable_type: [Answer.to_s, Proposal.to_s]) }

  def liked_by? someone
    likes.exists? user: someone
  end

  def voted_by voter
    votes.where(user: voter).first
  end

  def voted_by? voter
    votes.exists? user: voter
  end

  def agreed_by? voter
    votes.exists? user: voter, choice: 'agree'
  end

  def disagreed_by? voter
    votes.exists? user: voter, choice: 'disagree'
  end

  def hot?
    likes.past_week.count > HOT_LIKES_COUNT
  end

  def self.recommends_for_list(exclude)
    result = hottest.for_list.limit(10)
    if result.length < 10
      result += recent.for_list.limit(10)
      result = result.uniq
    end
    result - [exclude]
  end

  def self.hottest_count
    hottest.length
  end
end
