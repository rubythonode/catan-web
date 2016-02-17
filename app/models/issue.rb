class Issue < ActiveRecord::Base
  has_many :posts
  has_many :articles, through: :posts, source: :postable, source_type: Article
  has_many :opinions, through: :posts, source: :postable, source_type: Opinion

  validates :title, presence: true
end
