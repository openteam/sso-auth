require 'spec_helper'

describe Permission do
  it { should validates_presence_of :user }
end
