class Ability
  include CanCan::Ability


  def initialize(user)

    return unless user

    can :manage, Context do | context |
      user.manager_of?(context)
    end

    can :manage, Subcontext do | subcontext |
      can? :manage, subcontext.context
    end

    can :manage, Subcontext do | subcontext |
      user.manager_of?(subcontext)
    end

    can :manage, Permission do | permission |
      can? :manage, permission.context
    end

    can :create, Permission do | permission |
      user.manager?
    end

    can :manage, User do
      user.manager?
    end
  end
end
