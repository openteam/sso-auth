class Ability
  include CanCan::Ability


  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :modify

    can :modify, User do
      user.permissions.where(:role => :manager).exists?
    end

    can :modify, Permission do | permission |
      can? :modify, permission.user
    end

  end
end
