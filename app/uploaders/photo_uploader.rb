# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.album.user.id}/#{model.album.id}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :carousel do 
    process :resize_to_fit => [100, 67]
  end

  version :normal do
    process :resize_to_fit => [400, 400]
  end

  version :lightbox do
    process :resize_to_fit => [800, 800]
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

end
