class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, :unique => true
    User.all.map(&:save)
  end
end