class ChangeOperationsName < ActiveRecord::Migration[5.0]
  def up
    rename_column :operations, :mode, :background_mode
  end

  def down
  end
end
