class EspPermissionsAddRoleUserIdContextIdIndexToPermissions < ActiveRecord::Migration
  def change
    add_index :permissions, [:role, :context_id, :user_id]
  end
end
