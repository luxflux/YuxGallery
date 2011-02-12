class Photo < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :album_id
  
  belongs_to :album

  def user
    self.album.user
  end
end
