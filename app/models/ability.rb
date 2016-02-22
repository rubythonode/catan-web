class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :slug, Issue
    if user
      can :manage, Issue if user.admin?
      can :create, [Article, Opinion, Question, Answer, Comment, Vote, Like, Watch]
      can :manage, [Article, Opinion, Question, Answer, Comment, Like, Watch], user_id: user.id
    end
  end
end
