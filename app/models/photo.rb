class Photo < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :album_id
  
  has_friendly_id :name, :use_slug => true
  
  belongs_to :album

  def user
    self.album.user
  end

  def title
    self.name
  end

end
