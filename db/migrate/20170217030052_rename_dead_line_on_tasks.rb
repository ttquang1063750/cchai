class RenameDeadLineOnTasks < ActiveRecord::Migration[5.0]
  def change
    rename_column :tasks, :dead_line, :deadline
  end
end
