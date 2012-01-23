require 'spec_helper'

describe User do
  it { should have_many :permissions }
  it 'should set name if specified first and last names' do
    Fabricate(:user, :first_name => 'First', :last_name => 'Last', :name => nil).name.should == 'First Last'
  end
end
