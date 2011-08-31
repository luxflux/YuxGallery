class AddSlugToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :slug, :string
    add_index :photos, :slug, :unique => true
    Photo.all.map(&:save)
  end
end
