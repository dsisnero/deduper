require 'find'

module Deduper  

  class Scanner
    
    attr_reader :scan_dirs
    attr_reader :scanned_files, :exclude_paths

    def initialize(*path_array)
      raise ArgumentError if path_array.empty?
      paths = *path_array.flatten
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

    def exclude_proc(&block)
      @exclude_procs << block
    end


    def scan
      files = []
      begin
      Find.find(*scan_dirs)  do |path|
        
        if File.directory? path
          Find.prune if should_exclude?(path)
          Find.prune if path =~ /\.VirtualBox/
          next
        else
          next if should_exclude?(path)
          next unless File.exist?(path)          
          if block_given?
            yield path
          else
            files << path
          end
        end
      end
      
      return files unless block_given?
      end
      rescue
         nil
      end
    end

    def scanned_files
      @scanned_files ||= scan
    end

    

    def add_path(path)
      file = 
        @files << file
    end

  end
end
