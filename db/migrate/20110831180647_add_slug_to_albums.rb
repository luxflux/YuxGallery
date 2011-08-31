class AddSlugToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :slug, :string
    add_index :albums, :slug, :unique => true
    Album.all.map(&:save)
  end
end
