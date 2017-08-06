class CreateCsvExports < ActiveRecord::Migration[5.0]
  def change
    create_table :csv_exports do |t|
      t.string :name
      t.string :data_location
      t.string :stage

      t.timestamps
    end
  end
end
