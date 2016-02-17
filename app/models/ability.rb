class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :manage, Issue if user.admin?
      can :create, Article
      can :manage, Article, user_id: user.id
      can :create, Opinion
      can :manage, Opinion, user_id: user.id
    end
  end
end
