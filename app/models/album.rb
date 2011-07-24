# == Schema Information
# Schema version: 20110219144519
#
# Table name: albums
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  date_start  :datetime
#  date_end    :datetime
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos, :dependent => :destroy
  has_many :scans, :dependent => :destroy

  has_friendly_id :name, :use_slug => true

  validates_uniqueness_of :name, :scope => :user_id
  validates_presence_of   :name
  validate                :date_start_before_date_end


  def random_photo
    self.photos.shuffle.first
  end

  def date_start_before_date_end
    errors.add(:date_end, :should_be_after_date_start) if self.date_end && self.date_start && self.date_end < self.date_start
  end

  def title
    self.name
  end

end

