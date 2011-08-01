class AddCachedSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :cached_slug, :string
  end
end
