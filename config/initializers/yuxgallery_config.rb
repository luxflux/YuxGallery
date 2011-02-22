# path to the directory where users can upload their pictures via sftp
YuxGallery::Application.config.sftp_upload_path = File.join(Rails.root, "tmp", "upload")
