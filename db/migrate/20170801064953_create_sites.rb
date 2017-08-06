class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.references :user, foreign_key: true
      t.references :site_info, foreign_key: true

      t.timestamps
    end
  end
end
