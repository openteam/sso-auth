# encoding: utf-8

require 'spec_helper'

describe Permission do

  it { should belong_to :context }
  it { should belong_to :user }

  context 'validation' do
    it "dd" do
      permission = manager_of(root).permissions.new
      permission.context = child_1
      permission.role = :manager
      permission.should be_valid
    end
  end
end
