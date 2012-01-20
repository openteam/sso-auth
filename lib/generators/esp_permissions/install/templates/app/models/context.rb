class Context < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions

  attr_accessible :id, :title, :ancestry, :weight

  searchable do
    text :title
  end
end
