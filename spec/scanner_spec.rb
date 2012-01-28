require File.join( File.dirname(__FILE__), 'spec_helper')


describe "Deduper::Scanner" do
  
  describe "#initialization" do
    it "needs a path" do
      expect{
        @scanner = Deduper::Scanner.new
      }. to raise_error
    end

    module Enumerable
      # Simple parallel map using Celluloid::Futures
      def pmap(&block)
        futures = map { |elem| Celluloid::Future(elem, &block) }
        futures.map { |future| future.value }
      end
    end

    context "when given 1 path and no exclude" do
      before(:each) do
        @path = 'path'
        @scanner = Deduper::Scanner.new('path')
        
        subject{ @scanner}

        describe "scan_dirs" do
          it { should have(1).scan_dirs}
          it "should include path" do
            subject.scan_dirs.should include( File.expand_path('path'))
          end
        end

        describe "exclude paths" do
          it "sets the exclude_paths to empty array" do
            subject.exclude_paths.should be_empty
          end
          

        end

      end
    end

    context "when given 2 paths and no exclude" do
      
      subject{ Deduper::Scanner.new('path','path2') }


      describe "scan_dirs" do

        it "scan_dirs should have correct size" do
          subject.should have(2).scan_dirs
        end

        it "should have correct items" do
          subject.scan_dirs.should include(File.expand_path('path'))
          subject.scan_dirs.should include(File.expand_path('path2'))
        end
      end

      describe "exclude paths" do
        it "sets the exclude_paths to empty array" do
          subject.exclude_paths.should be_empty
        end

        

      end

      
    end

    context "when given path with exclude paths" do
      before(:each) do
        @exclude = ['**/.git', '**/.VirtualBox']
        @paths = ['path', 'path2']
        @scanner = Deduper::Scanner.new(@paths,:exclude => @exclude)
      end
      let(:paths) { @paths}
      let(:exclude_paths) { @exclude}
      subject { @scanner} 
      describe "scan_dirs" do
        it "should set the correct scan dirs" do
          @scanner.should have(2).scan_dirs
          paths.each do |p|
            subject.scan_dirs.should include(File.expand_path(p))
          end
        end
      end

      describe "exclude_paths" do
        it "should set the correct exclude dirs" do
          subject.should have(2).exclude_paths
          exclude_paths.each do |ex|
            subject.exclude_paths.should include(ex)
          end
        end
      end
    end

    
    context "when given home path and an exclude dir" do
      before(:each) do        
        @home_path = '~'
        @exclude = '**/.VirtualBox'
        @exclude_dir = File.expand_path("~/.VirtualBox")
        @scanner = Deduper::Scanner.new(@home_path, :exclude => @exclude)
      end
      let(:exclude_dir){@exclude_dir}    
      let(:home_path){ @home_path}

      subject{ @scanner}

      describe "#should_exclude?" do
        it "#should_exclude exclude a path that matches excludes" do          
          subject.should_exclude?(exclude_dir).should be_true
        end

        it "should call prune" do
          Find.should_receive(:prune)
          subject.scan
        end
      end
    end


  end

end
