require 'spec_helper'

describe Permission do
  it { should belong_to :context }
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should validate_uniqueness_of(:role).scoped_to(:user_id, :context_id, :context_type) }
  it { should ensure_inclusion_of(:role).in_array(%w[manager operator]) }
  it { should_not ensure_inclusion_of(:role).allow_nil }
  it { should_not ensure_inclusion_of(:role).allow_blank }
end
