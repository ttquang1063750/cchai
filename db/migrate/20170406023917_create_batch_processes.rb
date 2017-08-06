class CreateBatchProcesses < ActiveRecord::Migration[5.0]
  def change
    create_table :batch_processes do |t|
      t.references :project, foreign_key: true

      t.string :name
      t.integer :batch_process_type
      t.text    :operation, limit: 1073741823 # LONGTEXT for MySQL
      t.integer :repeat_time
      t.boolean :enable, default: false

      t.timestamps
    end
  end
end
