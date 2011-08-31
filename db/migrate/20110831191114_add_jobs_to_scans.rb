class AddJobsToScans < ActiveRecord::Migration
  def change
    add_column :scans, :jobs, :text
  end
end
