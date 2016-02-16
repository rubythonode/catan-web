class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :create, Article
      can :manage, Article, user_id: user.id
    end
  end
end
