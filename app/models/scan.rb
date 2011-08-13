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
#  runtime    :integer
#

class Scan < ActiveRecord::Base

  belongs_to :album
  belongs_to :job, :class_name => "Delayed::Backend::ActiveRecord::Job", :foreign_key => :job_id

  validates_presence_of :directory

  validate :validate_directory

  def validate_directory
    self.errors.add :directory, "../ is not allowed in the path" if self.directory =~ /\.\.\//
    self.errors.add :directory, "#{self.fullpath} does not exist" unless File.exists?(self.fullpath)
    self.errors.add :directory, "#{self.fullpath} is not a directory" unless File.directory?(self.fullpath)
  end

  before_create :set_state_on_create
  before_create :ensure_directory_is_a_directory
  after_create :run!

  def state
    if self[:state].nil? && new_record?
      set_state_on_create
    end
    self[:state].to_sym
  end

  def set_state_on_create
    self.state = :not_run
  end

  def ensure_directory_is_a_directory
    self.directory = File.dirname(self.fullpath) unless File.directory?(self.fullpath)
  end

  def fullpath
    File.join(self.album.user.sftp_folder, self.directory)
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
        speed = self.counter.zero? ? 0 : self.runtime / self.counter
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

