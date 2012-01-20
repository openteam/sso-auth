# encoding: utf-8

require 'spec_helper'

describe Ability do
  let(:root)                { Fabricate :context }
    let(:child_1)           { Fabricate :context, :parent => root }
      let(:category_1_1)    { Fabricate :context, :parent => child_1 }
    let(:child_1_1)         { Fabricate :context, :parent => child_1 }
    let(:child_2)           { Fabricate :context, :parent => root }

  def ability_for(user)
    Ability.new(user)
  end

  def user
    Fabricate(:user)
  end

  def manager_of(category)
    user.tap do | user |
      user.permissions.create! :context => category, :role => :manager
    end
  end

  context 'менеджер' do
    context 'телефонного справочника' do
      subject { ability_for(manager_of(root)) }

      context 'управление пользователями' do
        it { should be_able_to(:modify, user) }
        it { should be_able_to(:modify, manager_of(root)) }
        it { should be_able_to(:modify, manager_of(child_1)) }
        it { should be_able_to(:modify, manager_of(child_1_1)) }
        it { should be_able_to(:modify, manager_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:modify, user.permissions.new) }
        it { should be_able_to(:modify, manager_of(root).permissions.first) }
        it { should be_able_to(:modify, manager_of(child_1).permissions.first) }
        it { should be_able_to(:modify, manager_of(child_1_1).permissions.first) }
        it { should be_able_to(:modify, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should be_able_to(:modify, child_2) }
      end
    end

    context 'вложенного подразделения' do
      subject { ability_for(manager_of(child_1)) }

      context 'управление пользователями' do
        it { should be_able_to(:modify, user) }
        it { should be_able_to(:modify, manager_of(root)) }
        it { should be_able_to(:modify, manager_of(child_1)) }
        it { should be_able_to(:modify, manager_of(child_1_1)) }
        it { should be_able_to(:modify, manager_of(child_2)) }
      end

      context 'управление правами доступа' do
        it { should be_able_to(:modify, user.permissions.new) }
        it { should_not be_able_to(:modify, manager_of(root).permissions.first) }
        it { should be_able_to(:modify, manager_of(child_1).permissions.first) }
        it { should be_able_to(:modify, manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:modify, manager_of(child_2).permissions.first) }
      end

      context 'управление разделами' do
        it { should be_able_to(:modify, category_1_1) }
      end

      context 'управление подразделениями' do
        it { should_not be_able_to(:modify, root) }
        it { should be_able_to(:modify, child_1) }
        it { should be_able_to(:modify, child_1_1) }
        it { should_not be_able_to(:modify, child_2) }
      end
    end
  end
end
