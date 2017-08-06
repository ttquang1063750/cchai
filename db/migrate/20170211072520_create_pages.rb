class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :sluck
      t.binary :layout
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
