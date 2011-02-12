class AddColumnPhotoToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :photo, :string
  end

  def self.down
    remove_column :photos, :photo
  end
end
