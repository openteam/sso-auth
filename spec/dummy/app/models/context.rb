class Context < ActiveRecord::Base

  default_scope order('weight')

  attr_accessible :id, :title, :ancestry, :weight

  has_many :permissions
  has_many :users, :through => :permissions

  alias_attribute :to_s, :title

  has_ancestry

  searchable do
    text :title
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

