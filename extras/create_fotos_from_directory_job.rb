class CreateFotosFromDirectoryJob < Struct.new(:scan)

  def perform
    set_state :running
    set_progress 0

    @items = []
    if File.exists?(scan.fullpath)
      scan_dir(scan.fullpath)
    end
    
    set_total_items(@items.length)
    
    @items.each do |entry|
      photo = scan.album.photos.new(:photo => File.open(entry))
      photo.set_from_exif!
      photo.save!
#      File.delete(entry) if File.writable?(entry)
      add_to_progress
    end
  end

  def success(job)
    set_state :success
    set_run_data(job)
  end

  def error(job, exception)
    set_state :error
  end

  def failure
    set_state :fail
  end
  
  def set_state(state)
    scan.state = state
    scan.save!
  end

  def set_total_items(total)
    scan.item_count = total
    scan.save!
  end

  def set_progress(progress)
    scan.counter = progress
    scan.save!
  end

  def add_to_progress
    scan.counter += 1
    scan.save!
  end

  def set_run_data(job)
    scan.runtime = (Time.now - job.run_at).to_i
    scan.save!
  end

  def scan_dir(dir)
    Dir.entries(dir).each do |entry|
      next if [ "..", "." ].include?(entry)

      path = File.join(dir, entry)

      if File.directory?(path)
        scan_dir(path)
      else
        @items << path
      end
    end
  end

end

