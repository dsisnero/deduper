module Deduper

  

  class FileInfo
    
    attr_accessor :md5_head, :md5_tail, :md5

    def initialize(path)
      @path = path
      @stat = File.stat(path) rescue nil
    end

    def size
      @stat.size rescue 0
    end

  end
end
