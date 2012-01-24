require 'find'
module Deduper

  class Scanner
    
    attr_reader :scan_dirs
    attr_reader :scanned_files, :exclude_paths

    def initialize(*paths)
      raise ArgumentError if paths.empty?
      paths = *paths.flatten
      options = paths.last.class == Hash ? paths.pop : {}
      @scan_dirs = paths.map{|p| File.expand_path(p)}
      exclude_paths = options.fetch(:exclude){ []}
      @exclude_paths = Array(exclude_paths)
      @files = []
      yield self if block_given?
    end  

    def should_exclude?(path) 
      @exclude_paths.any?{|p| File.fnmatch(p,path)}
    end    

    def exclude(path)
      @exclude_paths << path
    end

    def scan
      files = []
      Find.find(*scan_dirs).each do |path|
        if File.directory? path
          Find.prune if should_exclude?(path)
          next
        else
          next if should_exclude?(path)
          next unless File.exist?(path)
          fileinfo = create_file(path)
          
          if block_given?
            yield fileinfo
          else
            files << fileinfo
          end
        end
      end
      files unless block_given?
      
    end

    def scanned_files
      @scanned_files ||= scan
    end

    def create_file(path)
      file = File.new(path)
      [path,file.size,file.stat.ino]
    end

    def add_path(path)
      file = 
      @files << file
    end

  end
end

