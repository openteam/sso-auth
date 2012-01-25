class Ability
  include CanCan::Ability


  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :modify

    can :modify, Context do | context |
      user.permissions.where(:role => :manager).where(:context_id => context.ancestor_ids + [context.id]).exists?
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
