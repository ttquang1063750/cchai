class AddExecutedAtToBatchProcesses < ActiveRecord::Migration[5.0]
  def change
    add_column :batch_processes, :executed_at, :datetime
  end
end
