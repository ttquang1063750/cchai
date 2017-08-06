class AddDetailsToProjects < ActiveRecord::Migration[5.0]
  def up
    change_column :projects, :name, :text
    add_column :projects, :short_name, :string
    add_column :projects, :patitent_num, :integer
    add_column :projects, :period_start_date, :date
    add_column :projects, :period_end_date, :date
  end

  def down
    change_column :projects, :name, :string
    remove_column :projects, :short_name
    remove_column :projects, :patitent_num
    remove_column :projects, :period_start_date
    remove_column :projects, :period_end_date

  end
end
