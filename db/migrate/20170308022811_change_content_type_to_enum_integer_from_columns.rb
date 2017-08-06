class ChangeContentTypeToEnumIntegerFromColumns < ActiveRecord::Migration[5.0]
  def up
    change_column :columns, :content_type, :integer, default: 0
  end

  def down
    change_column :columns, :content_type, :string
  end
end
