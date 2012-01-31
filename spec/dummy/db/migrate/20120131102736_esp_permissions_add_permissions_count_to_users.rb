class EspPermissionsAddPermissionsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permissions_count, :integer
  end
end
