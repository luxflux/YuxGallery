class AddColumnProgressToScans < ActiveRecord::Migration
  def self.up
    add_column :scans, :progress, :integer
  end

  def self.down
    remove_column :scans, :progress
  end
end
