class PhotoJob < ActiveRecord::Base

  belongs_to :job, :class_name => "Delayed::Backend::ActiveRecord::Job"
  belongs_to :scan

  scope :queued, where(:state => :queued)
  scope :finished, where(:state => [ :success, :failed ])

end
