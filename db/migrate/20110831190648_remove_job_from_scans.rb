class RemoveJobFromScans < ActiveRecord::Migration
  def up
    remove_column :scans, :job_id
  end

  def down
    add_column :scans, :job_id, :integer
  end
end
