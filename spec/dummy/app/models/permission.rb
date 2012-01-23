class Permission < ActiveRecord::Base
  belongs_to :context
  belongs_to :user, :counter_cache => true
  has_enum :role, :scopes => true

  attr_accessor :user_search, :user_uid, :user_first_name, :user_last_name, :user_email

  before_validation :reset_user_id, :unless => :user_id?

  validates_presence_of :role, :user, :context

  private
    def reset_user_id
      self.user_id = nil
      clear_attr_accessors
      self.errors[:user_search] = ::I18n.t('activerecord.errors.models.permission.attributes.user_id.blank')
    end

    def clear_attr_accessors
      self.user_uid = nil
      self.user_first_name = nil
      self.user_last_name = nil
      self.user_email = nil
    end
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer         not null, primary key
#  context_id   :integer
#  context_type :string(255)
#  user_id      :integer
#  role         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

