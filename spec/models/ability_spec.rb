# encoding: utf-8

require 'spec_helper'

describe Ability do
  let(:root)              { Fabricate :context }
  let(:child_1)           { Fabricate :context, :parent => root }
  let(:child_1_1)         { Fabricate :context, :parent => child_1 }
  let(:child_1_1)         { Fabricate :context, :parent => child_1 }
  let(:child_2)           { Fabricate :context, :parent => root }

  def ability_for(user)
    Ability.new(user)
  end

  def user
    @user = Fabricate(:user)
  end

  def manager_of(context)
    user.tap do | user |
      user.permissions.create! :context => context, :role => :manager
    end
  end

  def subcontext(context)
    Fabricate(:subcontext, :context => context).tap do | context |
      @user.permissions.create! :context => context, :role => :manager
    end
  end

  context 'менеджер' do
    context 'телефонного справочника' do
      subject { ability_for(manager_of(root)) }

      context 'управление пользователями' do
        it { should be_able_to(:manage, user) }
        it { should be_able_to(:manage, manager_of(root)) }
        it { should be_able_to(:manage, manager_of(child_1)) }
        it { should be_able_to(:manage, manager_of(child_1_1)) }
        it { should be_able_to(:manage, manager_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:create, user.permissions.new) }
        it { should be_able_to(:manage, manager_of(root).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление контекстами' do
        it { should be_able_to(:manage, root) }
        it { should be_able_to(:manage, child_1) }
        it { should be_able_to(:manage, child_1_1) }
        it { should be_able_to(:manage, child_1_1) }
        it { should be_able_to(:manage, child_2) }
      end

      context 'управление вложенными контекстами' do
        it { subject.should be_able_to(:manage, subcontext(root)) }
        it { subject.should be_able_to(:manage, subcontext(child_1)) }
        it { subject.should be_able_to(:manage, subcontext(child_1_1)) }
        it { subject.should be_able_to(:manage, subcontext(child_1_1)) }
        it { subject.should be_able_to(:manage, subcontext(child_2)) }
      end

    end

    context 'вложенного подразделения' do
      subject { ability_for(manager_of(child_1)) }

      context 'управление пользователями' do
        it { should be_able_to(:manage, user) }
        it { should be_able_to(:manage, manager_of(root)) }
        it { should be_able_to(:manage, manager_of(child_1)) }
        it { should be_able_to(:manage, manager_of(child_1_1)) }
        it { should be_able_to(:manage, manager_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:create, user.permissions.new) }
        it { should_not be_able_to(:manage, manager_of(root).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1).permissions.first) }
        it { should be_able_to(:manage, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:manage, child_1_1) }
      end

      context 'управление подразделениями' do
        it { should_not be_able_to(:manage, root) }
        it { should be_able_to(:manage, child_1) }
        it { should be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end
    end
  end
end
