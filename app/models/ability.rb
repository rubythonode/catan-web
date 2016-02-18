class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :manage, Issue if user.admin?
      can :create, [Article, Opinion, Comment]
      can :manage, [Article, Opinion, Comment], user_id: user.id
    end
  end
end
