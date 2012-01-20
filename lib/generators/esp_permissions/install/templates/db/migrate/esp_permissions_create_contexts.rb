class EspPermissionsCreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string :type
      t.string :title
      t.string :ancestry
      t.string :weight
      t.integer :position
      t.timestamps
    end
    add_index :contexts, :weight
    add_index :contexts, :ancestry
  end
end
