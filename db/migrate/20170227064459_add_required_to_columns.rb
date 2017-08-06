class AddRequiredToColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :columns, :required, :boolean, default: true
  end
end
