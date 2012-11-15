class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :application do
      user.permissions_exists?
    end

    can :manage, :permissions do
      user.manager?
    end

    # TODO: insert app specific rules here
  end
end
