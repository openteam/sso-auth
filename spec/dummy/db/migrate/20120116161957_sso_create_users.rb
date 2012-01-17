class SsoCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do | t |
      t.string  :uid            # omniauth[:uid]
      t.text    :name,          # omniauth[:info]
                :email,
                :nickname,
                :first_name,
                :last_name,
                :location,
                :description,
                :image,
                :phone,
                :urls
      t.text    :raw_info       # omniauth[:extra]
      t.trackable
      t.timestamps
    end

    add_index :users, :uid
  end
end
