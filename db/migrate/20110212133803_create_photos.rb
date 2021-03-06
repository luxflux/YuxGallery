class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :album
      t.string :name
      t.string :description
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
