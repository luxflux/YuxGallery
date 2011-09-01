class CreatePhotoJob < Struct.new(:file, :photo_job)

  def enqueue(job)
    photo_job.reload.state = :queued
    photo_job.save
  end

  def perform
    photo = photo_job.scan.album.photos.new(:photo => File.open(file))
    photo.set_from_exif!
    photo.save!
#    File.delete(file) if File.writable?(file)
  end

  def success(job)
    photo_job.reload.state = :success
    photo_job.save
  end

  def error(job, exception)
    photo_job.reload.state = :failed
    photo_job.save
  end

end
