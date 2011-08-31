class CreatePhotoJob < Struct.new(:file, :scan)

  def perform
    photo = scan.album.photos.new(:photo => File.open(file))
    photo.set_from_exif!
    photo.save!
#    File.delete(file) if File.writable?(file)
    scan.reload.counter += 1
    scan.save!
  end

end
