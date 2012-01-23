class Ability
  include CanCan::Ability


  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :modify

    can :modify, Context do | context |
      (user.contexts.where(:permissions => {:role => :manager}) & context.ancestors + [context]).any?
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
