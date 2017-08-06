class DropTableInstancesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :table_instances
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
