class Vote < ActiveRecord::Base
  extend Enumerize
  include PostTouchable

  belongs_to :user
  belongs_to :post, counter_cache: true

  enumerize :choice, in: [:agree, :disagree], predicates: true, scope: true

  validate :validate_post_type
  validates :user, uniqueness: {scope: [:post]}
  validates :post, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  before_save :touch_post_by_vote

  private

  def validate_post_type
    if post.postable_type != Opinion.to_s
      errors.add(:post, "should be opinion")
    end
  end
end
