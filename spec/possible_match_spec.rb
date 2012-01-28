require File.join( File.dirname(__FILE__),'spec_helper')
require 'ostruct'
require 'ruby-debug' if RUBY_VERSION =~ /1\.8/
MyFile = Struct.new(:name, :digest,:new_digest)

describe "Deduper::PossibleMatch" do


  describe "#initialize" do
    it "takes an array of files" do
      expect {Deduper::PossibleMatch.new}.to raise_error
    end
    
    it "sets the files" do
      pmatch = Deduper::PossibleMatch.new( 1,2,3,4)
      pmatch.files.should == [1,2,3,4]
    end

    context "a possible match class with initial values" do
      before(:each) do     
        @match_values = (1..10)
        @matches = Deduper::PossibleMatch.new(@match_values)
      end
      describe "pmatch" do
        it "correctly maps the files" do
          @matches.pmap{|f| f * 2}.should == @match_values.map{|f| f*2}
        end
      end
      
      context "update" do
        before(:each) do
          @items = (1..10).map{|i| MyFile.new("item#{i}")}
          @digest = %w(1 2 2 3 3 3 4 4 9 9)
          @double_items = %w(2 2 3 3 3 4 4 9 9)
          items = []
          @items.each_with_index do |item,idx| 
            item.digest = @digest[idx]
            items << item
          end
          @items_with_digest = items
          @matcher = Deduper::PossibleMatch.new(@items)
        end
        let(:digest){ @digest}
        let(:double_items) { @double_items}

        it "updates the item" do          
          result = @matcher.update_array(@items, "digest", @digest)
          result.map{|item| item.digest}.should == @digest
        end

        describe "#find_matches_for_array" do
          
          it "should work" , :fast do 
            result = @matcher.find_matches_for_array(@items_with_digest,'new_digest'){|item| item.digest }
            result.map{|item| item.new_digest}.should == double_items
            
          end
        end



        describe "#find_matches" do
          it "should update the value of the block" do
            @matcher.files[0].new_digest.should be_nil
            result = @matcher.find_matches('new_digest'){|item| item.digest}
            result[0].new_digest.should == "2"
          end
          
          it "should keep only the values that have more than one of the items the same" do
            result = @matcher.find_matches('new_digest'){|item| item.digest}
            result.map{|i| i.new_digest}.should == double_items
          end
        end

        
      end
    end

  end

end
