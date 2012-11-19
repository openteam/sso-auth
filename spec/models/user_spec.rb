# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  uid                :string(255)
#  name               :text
#  email              :text
#  raw_info           :text
#  sign_in_count      :integer
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe User do
  it { should have_many(:permissions).dependent(:destroy) }

  describe '.find_or_create_by_omniauth_hash' do
    let(:uid) { '1' }
    let(:name) { 'Anonymous User' }
    let(:email) { 'no@mail.here' }
    let(:first_name) { 'Firstname' }
    let(:middle_name) { 'Middlename' }
    let(:last_name) { 'Lastname' }
    let(:omniauth_hash) do
      {
        uid: uid,
        info: {
          name: name,
          email: email,
          first_name: first_name,
          last_name: last_name
        },
        extra: {
          raw_info: {
            user: {
              middle_name: middle_name
            }
          }
        }
      }
    end

    subject { User.find_or_create_by_omniauth_hash(omniauth_hash) }

    its(:email) { should == 'no@mail.here' }
    its(:uid) { should == '1' }
    its(:first_name) { should == 'Firstname' }
    its(:middle_name) { should == 'Middlename' }
    its(:last_name) { should == 'Lastname' }

    context 'user with same uid and another email already exists' do
      before { @user = User.create! :uid => '1', :email => 'there-are-no@mail.here' }
      it { should == @user }
      its(:email) { should == 'no@mail.here' }
    end

    context 'user with same email already exists' do
      before { @user = User.create! :email => 'no@mail.here' }
      it { should == @user }
    end

    context 'another user with no email eixsts an no email provided' do
      let(:email) { }
      before { @user = User.create! }
      it { should_not == @user }
    end
  end
end
