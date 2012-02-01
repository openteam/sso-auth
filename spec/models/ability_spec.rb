# encoding: utf-8

require 'spec_helper'

describe Ability do
  def ability_for(user)
    Ability.new(user)
  end

  context 'менеджер' do
    context 'корневого контекста' do
      subject { ability_for(manager_of(root)) }

      context 'управление контекстами' do
        it { should     be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should     be_able_to(:manage, child_2) }
      end

      context 'управление вложенными контекстами' do
        it { should     be_able_to(:manage, subcontext(root)) }
        it { should     be_able_to(:manage, subcontext(child_1)) }
        it { should     be_able_to(:manage, subcontext(child_1_1)) }
        it { should     be_able_to(:manage, subcontext(child_2)) }
      end

      context 'управление правами доступа' do
        it { should     be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end

    context 'вложенного подразделения' do
      subject { ability_for(manager_of(child_1)) }

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

      context 'управление вложенными контекстами' do
        it { should_not be_able_to(:manage, subcontext(root)) }
        it { should     be_able_to(:manage, subcontext(child_1)) }
        it { should     be_able_to(:manage, subcontext(child_1_1)) }
        it { should_not be_able_to(:manage, subcontext(child_2)) }
      end
    end
  end
end
