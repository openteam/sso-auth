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
