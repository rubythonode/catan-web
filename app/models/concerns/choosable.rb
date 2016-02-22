module Choosable
  extend ActiveSupport::Concern

  included do
    extend Enumerize
    enumerize :choice, in: [:agree, :disagree], predicates: true, scope: true
    scope :agreed, -> { where(choice: 'agree') }
    scope :disagreed, -> { where(choice: 'disagree') }
  end
end
