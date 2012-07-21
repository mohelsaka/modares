class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    # 0 points to add a qeustion
    can :create, Question if user.persisted?
    
    points = user.reputation_value_for :points
    # 10 points to add answer
    if points >= 10
      can :create, Answer
    end
    
    # user can't vote on his Videos, Answers and Questions
    can :vote, [Answer, Question, Video] do |object|
      user.persisted? && object.user_id != user.id
    end
    
    # signed in useres only can vote up
    if user.persisted?
      # can vote up
      can :vote_up, [Answer, Question, Video]
    end
    
    # 25 points to vote down
    if points >= 25
      # can vote down
      can :vote_down, [Answer, Question, Video]
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
