# == Schema Information
# Schema version: 20110220115323
#
# Table name: photos
#
#  id          :integer         not null, primary key
#  album_id    :integer
#  name        :string(255)
#  description :string(255)
#  date        :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  photo       :string(255)
#  shot_at     :datetime
#

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

  def exif_data(name = :all)
    self.photo.get_exif_data(name)
  end

  def set_from_exif(file = self.photo.path)
    #self.name = File.basename(self.photo.path) if self.name.nil? || self.name.empty?
    self.name = Time.now
    self.shot_at = self.exif_data(:date_time_original)
    self.description = "Created with #{self.exif_data(:model)}, edited with #{self.exif_data(:software)}"
  end

end

