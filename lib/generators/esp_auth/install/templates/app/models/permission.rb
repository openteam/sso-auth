class Permission < ActiveRecord::Base
  attr_accessor :user_search, :user_uid, :user_first_name, :user_last_name, :user_email, :polimorphic_context

  belongs_to :context, :polymorphic => true
  belongs_to :user, :counter_cache => true

  scope :for_roles,                 ->(*roles)                            { where(:role => roles) }
  scope :for_context_ancestors,     ->(context, ids=context.ancestor_ids) {
                                                                            where(:context_id => ids,
                                                                                  :context_type => (context.class.ancestors - context.class.included_modules).map(&:name))
                                                                          }
  scope :for_context,               ->(context)                           { where(:context_id => context.id, :context_type => context.class) }

  scope :for_context_and_ancestors, ->(context)                           {
                                                                            if context.respond_to?(:ancestor_ids)
                                                                              for_context_ancestors(context, context.ancestor_ids + [context.id])
                                                                            else
                                                                              for_context(context)
                                                                            end
                                                                          }

  before_validation :reset_user_attributes, :unless => :user_id?
  before_validation :set_context, :if => :polimorphic_context

  validates_presence_of :role, :user, :context

  validates_uniqueness_of :role, :scope => [:user_id, :context_id, :context_type]

  has_enum :role

  private
    def reset_user_attributes
      self.user_id = nil
      self.user_uid = nil
      self.user_first_name = nil
      self.user_last_name = nil
      self.user_email = nil
      self.errors[:user_search] = ::I18n.t('activerecord.errors.models.permission.attributes.user_id.blank')
    end

    def set_context
      underscored_context_type, self.context_id = polimorphic_context.match(/(\w+)_(\d+)/)[1..2]
      self.context_type = underscored_context_type.camelize
    end
end

# == Schema Information
#
# Table name: permissions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  context_id :integer
#  role       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

