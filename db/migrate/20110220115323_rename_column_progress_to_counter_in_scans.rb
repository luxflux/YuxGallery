class RenameColumnProgressToCounterInScans < ActiveRecord::Migration
  def self.up
    rename_column :scans, :progress, :counter
    add_column :scans, :item_count, :integer
    add_column :scans, :job_id, :integer
    add_column :scans, :runtime, :integer
  end

  def self.down
    remove_column :scans, :item_count
    rename_column :scans, :counter, :progress
    remove_column :scans, :job_id
    remove_column :scans, :runtime
  end
end
