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

  has_many :photo_jobs

  validates_presence_of :directory

  validate :validate_directory

  def validate_directory
    self.errors.add :directory, "../ is not allowed in the path" if self.directory =~ /\.\.\//
    self.errors.add :directory, "#{self.fullpath} does not exist" unless File.exists?(self.fullpath)
    self.errors.add :directory, "#{self.fullpath} is not a directory" unless File.directory?(self.fullpath)
  end

  before_create :ensure_directory_is_a_directory
  after_create :run!


  def ensure_directory_is_a_directory
    self.directory = File.dirname(self.fullpath) unless File.directory?(self.fullpath)
  end

  def fullpath
    File.join(self.album.user.sftp_folder, self.directory)
  end

  def run!
    if File.exists?(self.fullpath)
      items = scan_dir(self.fullpath)

      items.each do |item|
        new_job = self.photo_jobs.create
        dj = Delayed::Job.enqueue(CreatePhotoJob.new(item, new_job))
        new_job.job = dj
        new_job.save
      end
    end
  end

  def scan_dir(dir)
    items = []
    Dir.entries(dir).each do |entry|
      next if [ "..", "." ].include?(entry)

      path = File.join(dir, entry)

      if File.directory?(path)
        scan_dir(path)
      else
        items << path
      end
    end
    items
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
    when :queued
      state = "starting"
      speed = 0
      start = 0
    when :running
      state = "uploading"
      speed = (Time.now - self.created_at) / self.photo_jobs.finished.length
      start = self.created_at
    when :finished
      state = "done"
      speed = self.photo_jobs.finished.length.zero? ? 0 : self.runtime / self.photo_jobs.finished.length
      start = self.updated_at.to_i - self.runtime
    end

    {
      :state      => state,
      :received   => self.photo_jobs.finished.length,
      :size       => self.photo_jobs.length,
      :speed      => speed,
      :started_at => start,
      :uuid       => self.id
    }
  end

  def state
    case
    when self.photo_jobs.queued.length == self.photo_jobs.length
      :queued
    when self.photo_jobs.finished.length == self.photo_jobs.length
      unless self.runtime
        self.runtime = (Time.now - self.created_at).to_i
        self.save
      end
      :finished
    when self.photo_jobs.finished.length > 0
      :running
    end
  end

end

