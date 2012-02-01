class Subcontext < ActiveRecord::Base
  belongs_to :context
  has_many :permissions, :as => :context

  alias_attribute :to_s, :title

  def depth
    context.depth + 1
  end

end
