require_relative 'possible_match'
require_relative 'file_info'

require 'celluloid'




module Deduper

  class App

    attr_accessor :scanned_files,:possible_dups,:possible_matches,:matches

    def initialize(*args)
      
      @scanner = Scanner.new(*args)
      @original_files = []
      
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
        results << FileInfo.new(path)
      end
    end

    def scanned_files
      @scanned_files ||= run_scan
    end


    def possible_dups
      @possible_dups ||= run_match_by_size
    end

    def run_match_by_size
      index_by_size(scanned_files).select{|size,array| array.size > 1}
    end

    
    def run_possible_matches 
      possible_dups.values.map{|same| PossibleMatch.new(same)}
    end

    

    def possible_matches
      @possible_matches ||= run_possible_matches
    end
    
    def matches 
      @matches ||= run_matches     
    end  

    def run_matches
      possible_matches.map do |possibles|
        possibles.find_matched_files
      end
    end    

    def index_by_size(array)
      result = Hash.new{|h,k| h[k] = []}
      array.each do |file|
        result[size] << file
      end
      result
    end

    
    
    
  end

end

