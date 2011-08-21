class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user

    ###################
    # Access on User
    ###################
    can :read, User # everyone can read the users
    
    unless user.guest?
      can [ :update, :folders ], User, :id => user.id # user can edit/update only himself
    end
    
    if user.admin?
      can :destroy, User
    end


    ##################
    # Access on Album
    ##################
    can :read, Album # everyone can read the albums

    unless user.guest?
      can :manage, Album, :user => { :id => user.id }
    end

    ##################
    # Access on Scan
    ##################
    unless user.guest?
      can :manage, Scan, :album => { :user_id => user.id }
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
