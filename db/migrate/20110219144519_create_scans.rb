class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.references :album
      t.string :directory
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :scans
  end
end
