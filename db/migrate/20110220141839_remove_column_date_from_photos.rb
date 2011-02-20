class RemoveColumnDateFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :date
  end

  def self.down
    add_column :photos, :date, :datetime
  end
end
