class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :social_card], :all
    can [:slug, :users, :exist, :slug_posts, :slug_comments, :slug_campaign], Issue
    if user
      can :manage, [Issue, Related] if user.admin?
      can :create, [Article, Opinion, Question,
        Answer, Discussion, Proposal, Comment,
        Vote, Like, Watch]
      can :manage, [Article, Opinion, Question,
        Answer, Discussion, Proposal, Comment,
        Like, Watch], user_id: user.id
    end
  end
end
