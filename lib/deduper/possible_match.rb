require_relative 'hasher'

module Deduper

  class PossibleMatch

    attr_reader :files,:digester

    def initialize(*files) 
      raise if files.empty?
      files = files[0].to_a if files.size == 1
      files = files.flatten if files.instance_of? Array
      @files = files
      @digester = Hasher.new
    end

    def pmap(array = @files,  &block)
      if RUBY_VERSION =~ /1\.8/
        array.map(&block)
      else      
        array.pmap(&block)
      end
    end

    def files
      @files.to_a
    end

    def update_array(array,method,values)
      #debugger
      array.each_with_index do |item,index|
        method = method.chop if method =~ /=$/        
        item.send("#{method}=", values[index])
      end
    end

    def find_matches_for_array(array,attrib,&block)
      debugger
      attrib_values = array.pmap(&block)
      result = update_array(array,attrib,attrib_values)
      array.non_unique_by{|i| i.send(attrib)} 
    end

    
    

    def find_matches(attrib,&block)
      find_matches_for_array(@files,attrib,&block)
    end      

    def find_same_head(array)
      find_matches_for_array('md5_head'){|file| digester.digest_head(file)}
    end

    def find_same_tail(array)
      find_matches_for_array(array,'md5_tail'){|file| digester.digest_tail(file)}
    end

    def find_same_md5(array)
      find_matches_for_array(array,'md5'){|file| digester.md5_file(file)}
    end

    def find_matched_files
      @same_head = find_same_head(@files)
      @same_tail = find_same_tail(@same_head)
      @same_md5 = find_same_md5(@same_tail)
    end

    def matched_files
      @matched_files ||= find_matched_files
    end      
      
    

  end

end
