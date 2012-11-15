module SsoAuth
  module SpecHelper

    def ability_for(user)
      Ability.new(user)
    end

    def create_user
      @sequence ||= 0
      @sequence += 1
      User.create! :uid => @sequence, :name => "user #{@sequence}"
    end

    def user_with_role(role, context=nil, prefix=nil)
      @roles ||= {}
      @roles["#{prefix}_#{role}"] ||= {}
      @roles["#{prefix}_#{role}"][context] ||= create_user.tap do |user|
        user.permissions.create! :context => context, :role => role
      end
    end

    def user
      @user ||= create_user
    end

    def another_user
      @another_user ||= create_user
    end

    Permission.available_roles.each do | role |
      define_method "#{role}_of" do |context|
        user_with_role role, context
      end
      define_method "#{role}" do
        self.send("#{role}_of", nil)
      end
      define_method "another_#{role}_of" do |context|
        user_with_role role, context, "another"
      end
      define_method "another_#{role}" do
        self.send("another_#{role}_of", nil)
      end
    end
  end
end
