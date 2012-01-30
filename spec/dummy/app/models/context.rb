class Context < ActiveRecord::Base

  default_scope order('weight')

  attr_accessible :id, :title, :ancestry, :weight

  has_many :subcontexts
  has_many :permissions
  has_many :users, :through => :permissions

  scope :for_user, ->(user) { joins(:permissions).where(:permissions => {:user_id => user}) }

  alias_attribute :to_s, :title

  has_ancestry

  searchable do
    text :title
  end

  def self.available_for(user)
    @available_contexts ||= for_user(user).map(&:subtree).flatten.uniq.map{|c| c.respond_to?(:subcontexts) ? [c]+c.subcontexts : c }.flatten
  end

end
# == Schema Information
#
# Table name: contexts
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  weight     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

