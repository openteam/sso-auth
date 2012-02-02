class User < ActiveRecord::Base
  attr_accessible :name, :email, :nickname, :name, :first_name, :last_name, :location, :description, :image, :phone, :urls, :raw_info, :uid

  validates_presence_of :uid

  has_many :permissions

  default_value_for :sign_in_count, 0

  devise :omniauthable, :trackable, :timeoutable

  searchable do
    integer :uid
    text :term do [name, email, nickname].join(' ') end
    integer :permissions_count do permissions.count end
  end

  Permission.enums[:role].each do | role |
    define_method "#{role}_of?" do |context|
      permissions.for_role(role).for_context_and_ancestors(context).exists?
    end
    define_method "#{role}?" do
      permissions.for_role(role).exists?
    end
  end

  def contexts
    permissions.map(&:context).uniq
  end

  def contexts_tree
    contexts.flat_map{|c| c.respond_to?(:subtree) ? c.subtree : c}
            .uniq
            .flat_map{|c| c.respond_to?(:subcontexts) ? [c] + c.subcontexts : c }
            .uniq
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
#

