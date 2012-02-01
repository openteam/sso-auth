class Subcontext < ActiveRecord::Base
  belongs_to :context
  has_many :permissions, :as => :context

  alias_attribute :to_s, :title

  def depth
    context.depth + 1
  end
end
# == Schema Information
#
# Table name: subcontexts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  context_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

