class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can [:slug, :users], Issue
    if user
      can :manage, [Issue, Related] if user.admin?
      can :create, [Article, Opinion, Question, Answer, Discussion, Proposal, Comment, Vote, Like, Watch]
      can :manage, [Article, Opinion, Question, Answer, Discussion, Proposal, Comment, Like, Watch], user_id: user.id
    end
  end
end
