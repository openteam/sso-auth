class User < ActiveRecord::Base
  attr_accessible :name, :email, :nickname, :name, :first_name, :last_name, :location, :description, :image, :phone, :urls, :raw_info, :uid

  validates_presence_of :uid

  has_many :permissions

  default_value_for :sign_in_count, 0

  devise :omniauthable, :trackable, :timeoutable

  searchable do
    text :term do [name, email, nickname].join(' ') end
    integer :permissions_count
  end

  def manager?
    permissions.for_roles(:manager).exists?
  end

  def manager_of?(context)
    permissions.for_roles(:manager).for_context_and_ancestors(context).exists?
  end

  private

    delegate :count, :to => :permissions, :prefix => true
end



# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  uid                :string(255)
#  name               :text
#  email              :text
#  nickname           :text
#  first_name         :text
#  last_name          :text
#  location           :text
#  description        :text
#  image              :text
#  phone              :text
#  urls               :text
#  raw_info           :text
#  sign_in_count      :integer         default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  permissions_count  :integer
#

