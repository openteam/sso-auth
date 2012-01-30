class Subcontext < ActiveRecord::Base
  belongs_to :context
  has_many :permissions, :as => :context

  def depth
    context.depth + 1
  end
end
