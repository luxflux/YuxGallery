class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_friendly_id :name, :use_slug => true

  validates_uniqueness_of :name, :scope => :user_id
  validates_presence_of   :name
  validate                :date_start_before_date_end


  def date_start_before_date_end
    errors.add(:date_end, :should_be_after_date_start) if self.date_end && self.date_start && self.date_end < self.date_start
  end
end
