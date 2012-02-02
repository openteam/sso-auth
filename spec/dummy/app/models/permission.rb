class Permission < ActiveRecord::Base
  attr_accessor :user_search, :user_uid, :user_name, :user_email, :polimorphic_context

  belongs_to :context, :polymorphic => true
  belongs_to :user

  scope :for_role, ->(role) { where(:role => role) }
  scope :for_context_ancestors, ->(context, ids=context.ancestor_ids) do
    where(:context_id => ids,
          :context_type => (context.class.ancestors - context.class.included_modules).map(&:name))
  end
  scope :for_context, ->(context) { where(:context_id => context.id, :context_type => context.class) }

  scope :for_context_and_ancestors, ->(context) do
    if context.respond_to?(:ancestor_ids)
      for_context_ancestors(context, context.ancestor_ids + [context.id])
    else
      for_context(context)
    end
  end

  after_initialize :set_user, :if => :user_uid_present?
  after_initialize :set_context, :if => :polimorphic_context_present?

  after_create :user_index!
  after_destroy :user_index!

  validates_presence_of :polimorphic_context, :unless => :context

  validates_presence_of :role, :user, :context

  validates_presence_of :user_search, :unless => :user

  validates_uniqueness_of :role, :scope => [:user_id, :context_id, :context_type]

  has_enum :role


  private

    def set_user
      self.user = User.find_or_initialize_by_uid(user_uid).tap do |user|
        user.update_attributes :name => user_name, :email => user_email
      end
    end

    def set_context
      underscored_context_type, self.context_id = polimorphic_context.match(/(\w+)_(\d+)/)[1..2]
      self.context_type = underscored_context_type.camelize
    end

    delegate :index!, :to => :user, :prefix => true
    delegate :present?, :to => :polimorphic_context, :prefix => true
    delegate :present?, :to => :user_uid, :prefix => true
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

