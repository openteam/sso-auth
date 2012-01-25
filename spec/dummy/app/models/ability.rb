class Ability
  include CanCan::Ability


  def initialize(user)

    return unless user

    can :manage, Context do | context |
      user.permissions.for_roles(:manager).for_context(context).exists?
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
