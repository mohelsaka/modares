class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      # 0 points to add a qeustion
      can :create, VideoQuestion
      
      points = user.reputation_value_for :points
      # 10 points to add answer
      can :create, VideoAnswer if points >= 10
      
      # user can't vote on his Videos, VideoAnswers and VideoQuestions
      can :vote, [VideoAnswer, VideoQuestion, Video] do |object|
        object.user_id != user.id
      end
      
      # 0 points to vote up
      # can vote up
      can :vote_up, [VideoAnswer, VideoQuestion, Video]
      
      # 25 points to vote down
      # can vote down
      can :vote_down, [VideoAnswer, VideoQuestion, Video] if points >= 25
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
