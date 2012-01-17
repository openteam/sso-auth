# encoding: utf-8

class Context < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer         not null, primary key
#  title          :text
#  abbr           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  ancestry       :string(255)
#  position       :integer
#  url            :text
#  type           :string(255)
#  weight         :string(255)
#  info_path      :string(255)
#  ancestry_depth :integer         default(0)
#

