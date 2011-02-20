# == Schema Information
# Schema version: 20110220141839
#
# Table name: photos
#
#  id          :integer         not null, primary key
#  album_id    :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  photo       :string(255)
#  shot_at     :datetime
#

class Photo < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  validates_presence_of :name
  
  has_friendly_id :name, :use_slug => true
  
  belongs_to :album

  before_create :set_from_exif

  def user
    self.album.user
  end

  def title
    self.name
  end

  def exif_data(name = :all)
    self.photo.get_exif_data(name)
  end

  def set_from_exif(force = false)
    self.name = File.basename(self.photo.path) if self.name.nil? || self.name.empty? || force
    self.shot_at = self.exif_data(:date_time_original) if self.shot_at.nil? || force
    self.description = "Created with #{self.exif_data(:model)}, edited with #{self.exif_data(:software)}" if self.description.nil? || self.description.empty? || force
  end

end

