require_relative 'spec_helper'

describe "Deduper::Scanner" do
  
  describe "#initialization" do
    it "needs a path" do
      expect{
        @scanner = Deduper::Scanner.new
      }. to raise_error
    end

    context "when given 2 paths" do
      subject{ Deduper::Scanner.new('path','path') }
      

      it "sets the scan_dirs" do
        subject.should have(2).scan_dirs
      end

      it "sets the exclude_paths to empty array" do
        subject.exclude_paths.should be_empty
      end

      it "sets the exclude_path" do
        subject.exclude_paths.should == []
      end

    end

    context "when given 2 paths and an exclude dir" do
      before(:each) do
        @path1 = '**/*.git'
        @path2 = '**/*.rb'
      end

      subject{ Deduper::Scanner.new('path1','path2', :exclude => [@path1,@path2])}
      
      it "sets the scan_dirs" do
        subject.should have(2).scan_dirs
      end

      it "sets the exclude_paths" do
        subject.should have(2).exclude_paths
      end

      it "should have the correct exclude_paths" do
        [@path1,@path2].each do |path|
          subject.exclude_paths.should include(path)
        end
      end

    end
    
    context "given a home directory and a scanner" do
      subject{ Deduper::Scanner.new('~/programming', :exclude => '**/.git')}

      it "should call find with dir" do
        Find.should_receive(:scan).with('/home/dominic/programming')
        subject.scan
      end
      
      it "should have 10 values" do
        subject.scan.should have(2).items
      end

      it "should have the correct value" do
        subject.scan[0].should == ['test',10,5]
        end

    end

    

  end

end
