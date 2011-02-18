require 'range_validator'

describe "RangeValidator" do

  before(:each) do
    TestModel.reset_callbacks(:validate)
    @ranges = { :january             => Date.civil(2011,1,1)..Date.civil(2011,1,31),
                :february            => Date.civil(2011,2,1)..Date.civil(2011,2,28),
                :january_to_february => Date.civil(2011,1,1)..Date.civil(2011,2,28)}
  end

  it "should not be valid when the field is not a range" do
    TestModel.validates :name, :range => true
    record = TestModel.new({:name => "name"})

    record.should_not be_valid
    record.errors.should == {:name => ["is not a range"]}
  end

  context "overlapping" do
    
    before(:each) do
      TestModel.validates :date_range, :range => { :overlapping => :other_records }
    end
    
    it "should be valid when there is overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:january_to_february], :other_records => [record1]})

      record2.should be_valid
    end
    
    it "should not be valid when there is no overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:february], :other_records => [record1]})

      record2.should_not be_valid
      record2.errors.should == {:date_range => ["does not overlap"]}
    end
    
  end

  context "not_overlapping" do
    
    before(:each) do
      TestModel.validates :date_range, :range => { :not_overlapping => :other_records }
    end

    it "should be valid when there is no overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:february], :other_records => [record1]})

      record2.should be_valid
    end
    
    it "should not detect overlap with other records with the same object_id" do
      record = TestModel.new({:date_range => @ranges[:january]})
      record.other_records = [record]
      
      record.should be_valid
    end
    
    it "should not detect overlap with other records with the same to_key value" do
      record1 = TestModel.new({:date_range => @ranges[:january], :to_key => [1]})
      record2 = TestModel.new({:date_range => @ranges[:january], :to_key => [1]})
      record2.other_records = [record1]
      
      record2.should be_valid
    end

    it "should not be valid when there is an overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:january_to_february], :other_records => [record1]})

      record2.should_not be_valid
      record2.errors.should == {:date_range => ["overlaps"]}
    end
    
  end

end
