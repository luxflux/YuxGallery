# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.album.user.id}/#{model.album.id}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [125, 125]
  end

  version :carousel do 
    process :resize_to_fit => [100, 67]
  end

  version :normal do
    process :resize_to_fit => [200, 200]
  end

  version :lightbox400 do
    process :resize_to_fit => [600, 400]
  end

  version :lightbox800 do
    process :resize_to_fit => [ 1200, 800 ]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png tiff tif)
  end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end
  
  def get_exif_data(name = :all)
    path = current_path
    case File.basename(path).downcase
      when /\.jpe?g\Z/
        exif_info = EXIFR::JPEG.new(path)
      when /\.tiff?\Z/
        exif_info = EXIFR::TIFF.new(path)
    end

    if exif_info && exif_info.exif
      exif = exif_info.exif.to_hash
      if name == :all
        exif
      else
        exif[name]
      end 
    else
      if name == :all
        {}  
      else
        nil 
      end 
    end
  end
end
