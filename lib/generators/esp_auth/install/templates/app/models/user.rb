class User < ActiveRecord::Base
  attr_accessible :name, :email, :nickname, :first_name, :last_name, :location, :description, :image, :phone, :urls, :raw_info, :uid

  validates_presence_of :uid

  has_many :permissions

  scope :with_permissions, where('permissions_count > 0')

  before_create :set_name, :unless => :name?

  default_value_for :sign_in_count, 0
  default_value_for :permissions_count, 0

  devise :omniauthable, :trackable, :timeoutable

  searchable do
    text :name, :email, :nickname, :phone, :last_name, :first_name
    integer :permissions_count
  end

  def self.from_omniauth(hash)
    User.find_or_initialize_by_uid(hash['uid']).tap do |user|
      user.update_attributes hash['info']
    end
  end

  def manager?
    permissions.for_roles(:manager).exists?
  end

  def manager_of?(context)
    permissions.for_roles(:manager).for_context_and_ancestors(context).exists?
  end

  protected

    def set_name
      self.name = [first_name, last_name].join(' ')
    end
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
