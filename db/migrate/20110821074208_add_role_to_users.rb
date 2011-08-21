class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    User.all.each do |user|
      user.role = :user
      user.save
    end
  end
end
