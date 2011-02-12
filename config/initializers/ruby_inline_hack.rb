require "inline"

class Inline::C
  def load
    require "#{so_name}"
    #below is the original version which breaks
    #require "#{so_name}" or raise LoadError, "require on #{so_name} failed"
  end
end

require "image_science"
