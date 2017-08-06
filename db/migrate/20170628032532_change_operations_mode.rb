class ChangeOperationsMode < ActiveRecord::Migration[5.0]
    def up
      change_table :operations do |t|
        t.change :mode, :integer
      end
    end

    def down
      change_table :operations do |t|
        t.change :mode, :string
      end
    end
end
