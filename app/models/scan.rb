# == Schema Information
# Schema version: 20110220115323
#
# Table name: scans
#
#  id         :integer         not null, primary key
#  album_id   :integer
#  directory  :string(255)
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  counter    :integer
#  item_count :integer
#  job_id     :integer
#

class Scan < ActiveRecord::Base

  belongs_to :album
  belongs_to :job, :class_name => "Delayed::Backend::ActiveRecord::Job", :foreign_key => :job_id

  validates_each :directory do |record,attr,value|
    record.errors.add attr, "../ is not allowed in the path" if value =~ /\.\.\//
  end

  before_create :set_state_on_create
  before_create :make_directory_a_directory

  def title
    self.id
  end

  def state
    self[:state].to_sym
  end

  def set_state_on_create
    self.state = :not_run
  end

  def make_directory_a_directory
    self.directory = File.dirname(self.directory) unless File.directory?(self.directory)
  end

  def run!
    self.state = :queued
    self.job = Delayed::Job.enqueue CreateFotosFromDirectoryJob.new(self)
    self.save!
  end

  def status
    # we have to fake the upload-status reply to
    # be able to use the form-uploader-functionality of rightjs
    #
    # state => state of the scan
    # received => how much we did
    # size => how many we have to do
    # speed => now - start time / received
    # started_at => scan start
    # uuid => scan id
    
    case self.state
      when :queued, :not_run
        state = "starting"
        speed = 0
        start = 0
      when :running
        state = "uploading"
        speed = (Time.now - self.job.run_at) / self.counter
        start = self.job.run_at
      when :success
        state = "done"
        speed = self.runtime / self.counter
        start = self.updated_at.to_i - self.runtime
      when :error, :fail
        state = "error"
        speed = (Time.now - self.job.failed_at) / self.counter
        start = self.job.run_at
    end

    {
      :state      => state,
      :received   => self.counter,
      :size       => self.item_count,
      :speed      => speed,
      :started_at => start,
      :uuid       => self.id
    }
  end

end

