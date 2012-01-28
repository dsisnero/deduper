if RUBY_VERSION =~ /1\.8/
  require 'ruby-debug'
  
end

module Enumerable

  def non_unique_by
    mhash = Hash.new{|h,k| h[k] = []}
    each do |i|
      mhash[yield(i)] << i
    end
    result = mhash.select{|k,v| v.size > 1}
    return result.values.flatten if RUBY_VERSION =~ /1\.9/
    return result.map{|p| p[1]}.flatten if RUBY_VERSION =~ /1\.8/
  end

  # def non_uniq_by
  #   mhash = Hash.new{|h,k| h[k] = []}
  #   each do |i|
  #     mhash[yield(i)] << i
  #   end
  #   mhash.select{|k,v| v.size > 1}.values.flatten
  # end

  
  def uniq_by
    mhash, array = {}, []
    each do |i|
      mhash[yield(i)] ||= (array << i)
    end
    array
  end
  
  
end



if RUBY_VERSION =~ /1\.9/
  require 'celluloid'
  module Enumerable
    # Simple parallel map using Celluloid::Futures
    def pmap(&block)
      futures = map { |elem| Celluloid::Future(elem, &block) }
      futures.map { |future| future.value }
    end
  end
end
