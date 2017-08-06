class CreateSiteInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :site_infos do |t|
      t.string :number
      t.string :name
      t.string :remarks
      t.string :address
      t.string :tel
      t.string :fax
      t.references :project, foreign_key: true
      
      t.timestamps
    end
  end
end
