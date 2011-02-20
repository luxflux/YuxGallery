class AddColumnTakenAtToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :shot_at, :datetime 
  end

  def self.down
    drop_column :photos, :shot_at
  end
end
