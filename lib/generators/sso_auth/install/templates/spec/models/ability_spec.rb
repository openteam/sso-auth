require 'spec_helper'

describe Ability do
  context 'manager' do
    subject { ability_for(manager) }
    it { should     be_able_to(:manage, :application) }
    it { should     be_able_to(:manage, :permissions) }
  end
  context 'operator' do
    subject { ability_for(operator) }
    it { should     be_able_to(:manage, :application) }
    it { should_not be_able_to(:manage, :permissions) }
  end
end
