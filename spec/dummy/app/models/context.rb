class Context < ActiveRecord::Base

  default_scope order('weight')

  attr_accessible :id, :title, :ancestry, :weight, :parent

  has_many :subcontexts
  has_many :permissions, :as => :context


  alias_attribute :to_s, :title

  has_ancestry

end
# == Schema Information
#
# Table name: contexts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  ancestry   :string(255)
#  weight     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

