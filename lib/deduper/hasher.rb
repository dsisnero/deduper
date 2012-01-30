#require 'celluloid'
require 'digest/md5'

# Ask the hasher to perform a complex computation. However, since we're using
# a future, this doesn't block the current thread
#future = hasher.future(:md5_file, file_path)
#future = hasher.future(:digest_head,file)
# future = hasher.future(:digest_tail, file)
# files.map{|f| hasher.future(:md5_file, f}
# files.each do |path|
#   hash = hasher.future(:md5_file, f)
#   file_hash[hash.value] << f
# end



class Hasher
 # include Celluloid

  class << self
    attr_accessor :blksize
  end

  @blksize ||= 8192

  def initialize(blksize= nil)
    @blksize = blksize || self.class.blksize
  end

  def digest_head(file, blksize = @blksize)
    file = File.new(file)
    Digest::MD5.hexdigest(file.read(blksize))
  end

  def digest_tail(filename,blksize = @blksize)
    file = File.new(filename)
    file.seek(-blksize, IO::SEEK_END) if file.stat.size > blksize
    Digest::MD5.hexdigest(file.read(blksize))
  end    

  def md5_file(file, blksize = @blksize)
    digest = Digest::MD5.new
    File.open(file,'rb') do |io|
      buffer = ''
      while buffer = io.read(blksize)
        digest.update(buffer)
      end
    end
    digest.digest
  end
  
end

