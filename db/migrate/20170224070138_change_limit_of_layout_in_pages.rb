class ChangeLimitOfLayoutInPages < ActiveRecord::Migration[5.0]
  def up
    change_column :pages, :layout, :binary, limit: 16777215
  end

  def down
    change_column :pages, :layout, :binary, limit: 65535
  end
end
