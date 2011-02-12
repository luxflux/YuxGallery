class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name
      t.datetime :date_start
      t.datetime :date_end
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
