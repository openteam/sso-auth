# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Permission do
  it { should belong_to :context }
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should validate_uniqueness_of(:role).scoped_to(:user_id, :context_id, :context_type) }
  it { should ensure_inclusion_of(:role).in_array(%w[manager operator]) }
  it { should ensure_inclusion_of(:role).in_array([:manager, :operator]) }
  it { should_not ensure_inclusion_of(:role).allow_nil }
  it { should_not ensure_inclusion_of(:role).allow_blank }
end
