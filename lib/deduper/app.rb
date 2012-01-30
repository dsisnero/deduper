require_relative 'possible_match'
require_relative 'file_info'

require 'celluloid'




module Deduper

  class App

    attr_accessor :scanned_files,:possible_dups,:possible_matches,:matches, :zero_sized_files

    def initialize(*args)
      
      @scanner = Scanner.new(*args)
      @original_files = []
      @zero_sized_files = []
      
    end

    def run
      run_scan
      run_match_by_size
      run_possible_matches
      run_matches
    end

    def run_scan
      results = []
      @scanner.scan do |path|
        file = FileInfo.new(path)
        if file.size == 0
          @zero_sized_files << file
        else
          results << file
        end
      end
      @scanned_files = results
      results
    end

    def scanned_files
      @scanned_files ||= run_scan
    end


    def possible_dups
      @possible_dups ||= run_match_by_size
    end

    def run_match_by_size
      indexed_by_size.select{|key,values| values.size > 1}.values
    end

    
    def run_possible_matches 
      possible_dups.map{|same| PossibleMatch.new(same)}
    end    

    def possible_matches
      @possible_matches ||= run_possible_matches
    end
    
    def matches 
      @matches ||= run_matches     
    end  

    def run_matches
      possible_matches.map do |possibles|
        possibles.matched_files
      end
    end    

    def indexed_by_size(array = scanned_files)
      @index_by_size ||= run_index_by_size(array)
    end

    def run_index_by_size(array = scanned_files)      
      result = Hash.new{|h,k| h[k] = []}      
      array.each do |file|
        result[file.size] << file
      end
      result
    end

    
    
    
  end

end

