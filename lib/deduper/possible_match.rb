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

    def md5_head(array = @files)
      array.pmap do |f|
        digest =  digester.digest_head(file.path)
        f.md5_head = digest
      end
    end

    def md5_tail(array =same_head)
      array.pmap do |f|
        digest = digester.digest_tail(file.path)
        f.md5_tail = digest
      end
    end

    def md5(array = same_tail)
      array.pmap do |f|
        digest = digester.md5(file.path)
        f.md5 = digest
      end
    end



    def same_head
      @same_head ||= md5_head(@files).non_unique_by{|i| i.md5_head}
    end

    def same_tail
      @same_tail ||= md5_tail(same_head).non_unique_by{|i| i.md5_tail}
    end

    def same_md5
      @same_md5 ||= md5(same_tail).non_unique_by{|i| i.md5_tail}
    end

    
      

   #  def update_array(array,method,values)
  #     #debugger
  #     array.each_with_index do |item,index|
  #       method = method.chop if method =~ /=$/        
  #       item.send("#{method}=", values[index])
  #     end
  #   end

  #   def find_matches_for_array(array,attrib,&block)
  # #    debugger
  #     attrib_values = array.pmap(&block)
  #     result = update_array(array,attrib,attrib_values)
  #     array.non_unique_by{|i| i.send(attrib)} 
  #   end

  #   def same_head(array = @files)
  #     @same_head ||= find_same_head(array)
  #   end
      
  #   def same_tail(array = same_head)
  #     @same_tail ||= find_same_tail(array)
  #   end

  #   def same_md5(array = same_tail)
  #     @same_md5 ||= find_same_md5(array)
  #   end

    def matched_files
      same_md5.select{|m| m.size > 1 }
    end

    # def size
    #   matched_files.size
    # end
    
    

    # def find_matches(attrib,&block)
    #   find_matches_for_array(@files,attrib,&block)
    # end      

    # def find_same_head(array)
    #   find_matches_for_array(array, 'md5_head'){|file|}
    # end

    # def find_same_tail(array)
    #   find_matches_for_array(array,'md5_tail'){|file| digester.digest_tail(file.path)}
    # end

    # def find_same_md5(array)
    #   find_matches_for_array(array,'md5'){|file| digester.md5_file(file.path)}
    # end      
    

  end

end
