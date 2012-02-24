module EspAuth
  module SpecHelper

    def ability_for(user)
      Ability.new(user)
    end

    def create_user
      @sequence ||= 0
      @sequence += 1
      User.create! :uid => @sequence, :name => "user #{@sequence}"
    end

    def user_with_role(role, context=root, prefix=nil)
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

    def create_context(parent=nil)
      Context.create! :title => 'context', :parent => parent
    end

    def create_subcontext(context)
      Subcontext.create! :title => 'subcontext', :context => context
    end

    def root
      @root ||= create_context
    end

    def child_1
      @child_1 ||= create_context root
    end

    def child_1_1
      @child_1_1 ||= create_context child_1
    end

    def child_1_2
      @child_1_2 ||= create_context child_1
    end

    def child_2
      @child_2 ||= create_context root
    end

    def subcontext(context)
      @subcontext ||= create_subcontext(context)
    end

    def another_subcontext(context)
      @another_subcontext ||= create_subcontext(context)
    end

    Permission.enums[:role].each do | role |
      define_method "#{role}_of" do |context|
        user_with_role role, context
      end
      define_method "#{role}" do
        self.send("#{role}_of", root)
      end
      define_method "another_#{role}_of" do |context|
        user_with_role role, context, "another"
      end
      define_method "another_#{role}" do
        self.send("another_#{role}_of", root)
      end
    end
  end
end
