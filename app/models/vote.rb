class Vote < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :opinion

  enumerize :choice, in: [:agree, :disagree], predicates: true, scope: true

  scope :recent, -> { order(updated_at: :desc) }
end
