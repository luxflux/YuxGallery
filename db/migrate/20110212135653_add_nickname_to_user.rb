class AddNicknameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :nickname, :string
    
    User.all.each do |user|
      user.nickname = user.email
      user.save!
    end
  end

  def self.down
    remove_column :users, :nickname
  end
end
