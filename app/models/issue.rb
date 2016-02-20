class Issue < ActiveRecord::Base
  TITLE_OF_ASK_PARTI = 'ask-parti'
  OF_ALL = RecursiveOpenStruct.new({
    is_all?: true, title: '모두 보기', slug: 'all', logo: {file: nil}, cover: {file: nil}})

  has_many :posts
  has_many :articles, through: :posts, source: :postable, source_type: Article
  has_many :opinions, through: :posts, source: :postable, source_type: Opinion
  has_many :watches

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  mount_uploader :logo, ImageUploader
  mount_uploader :cover, ImageUploader

  def watched_by? someone
    watches.exists? user: someone
  end

  def is_all?
    false
  end

  def set_slug
    return if self.title.blank?
    self.slug = self.title.strip.downcase.gsub(/\s+/, "-")
  end
end
