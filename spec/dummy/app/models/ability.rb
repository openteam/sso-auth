class Ability
  include CanCan::Ability


  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :modify

    can :modify, Context do | context |
      user.permissions.for_roles(:manager).for_context(context).exists?
    end

    can :modify, Permission do | permission |
      can? :modify, permission.context
    end

    can :modify, Permission do | permission |
      !permission.context && user.manager?
    end

    can :modify, User do
      user.manager?
    end
  end
end
