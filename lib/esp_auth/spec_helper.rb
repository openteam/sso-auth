module EspAuth
  module SpecHelper

    def ability_for(user)
      Ability.new(user)
    end

    def user
      @user ||= User.create! :uid => 1, :name => 'User'
    end

    def another_user
      @another_user ||= User.create! :uid => 2, :name => 'Another user'
    end

    def subcontext(context)
      @subcontext ||= Subcontext.create!(:context => context).tap do | subcontext |
                        another_user.permissions.create! :context => subcontext, :role => :manager
                      end
    end

    Permission.enums[:role].each do | role |
      define_method "another_#{role}_of" do |context|
        another_user.tap do | another_user |
          another_user.permissions.create! :context => context, :role => role
        end
      end
    end

    Permission.enums[:role].each do | role |
      define_method "#{role}_of" do |context|
        user.tap do | user |
          user.permissions.create! :context => context, :role => role
        end
      end
    end

    def root
      @root ||= Context.create! :title => 'root'
    end

    def child_1
      @child_1 ||= Context.create! :title => 'child_1', :parent => root
    end

    def child_1_1
      @child_1_1 ||= Context.create! :title => 'child_1_1', :parent => child_1
    end

    def child_1_2
      @child_1_2 ||= Context.create! :title => 'child_1_2', :parent => child_1
    end

    def child_2
      @child_2 ||= Context.create! :title => 'child_2', :parent => root
    end
  end
end
