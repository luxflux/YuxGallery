class RemoveFieldsFromScans < ActiveRecord::Migration
  def up
    [ :state, :counter, :item_count, :jobs ].each do |col|
      remove_column :scans, col
    end
  end

  def down
    add_column :scans, :state, :string
    add_column :scans, :counter, :integer
    add_column :scans, :item_count, :integer
    add_column :scans, :jobs, :text
  end
end
