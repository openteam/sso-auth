class EspPermissionsCreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :context
      t.string :role
      t.timestamps
    end
  end
end
