class DropCurrentUsersTable < ActiveRecord::Migration
  def up
    drop_table :current_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
