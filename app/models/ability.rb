class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :slug, Issue
    if user
      can :manage, Issue if user.admin?
      can :create, [Article, Opinion, Comment, Vote, Like]
      can :manage, [Article, Opinion, Comment, Like], user_id: user.id
    end
  end
end
