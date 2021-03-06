require 'range_validator'
require 'spec_helper'

describe "RangeValidator" do

  before(:each) do
    TestModel.reset_callbacks(:validate)
    @ranges = { :january             => Date.civil(2011,1,1)..Date.civil(2011,1,31),
                :february            => Date.civil(2011,2,1)..Date.civil(2011,2,28),
                :january_to_february => Date.civil(2011,1,1)..Date.civil(2011,2,28)}
  end

  it "should be valid when the field is a range" do
    TestModel.validates :duration, :range => true
    record = TestModel.new({:duration => 0..1})
  
    record.should be_valid
  end
  
  it "should not be valid when the field is not a range" do
    TestModel.validates :name, :range => true
    record = TestModel.new({:name => "name"})
  
    record.should_not be_valid
    record.errors.should == {:name => ["is not a range"]}
  end

  describe "overlapping" do

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
    
    it "should not be valid when overlapping an empty set" do
      record = TestModel.new({:date_range => @ranges[:january], :other_records => []})
      record.should_not be_valid
      record.errors.should == {:date_range => ["does not overlap"]}
    end
    
    it "should not be valid when overlapping nil" do
      record = TestModel.new({:date_range => @ranges[:january], :other_records => nil})
      record.should_not be_valid
      record.errors.should == {:date_range => ["does not overlap"]}
    end
    
    it "should throw an error when given a bad argument" do
      expect {
        TestModel.validates :duration, :range => { :overlapping => nil }
      }.to raise_error ArgumentError, ":overlapping must be a symbol or a proc"
    end

  end

  describe "not_overlapping" do

    before(:each) do
      TestModel.validates :date_range, :range => { :not_overlapping => :other_records }
    end

    it "should be valid when there is no overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:february], :other_records => [record1]})

      record2.should be_valid
    end

    it "should not be valid when there is an overlap" do
      record1 = TestModel.new({:date_range => @ranges[:january]})
      record2 = TestModel.new({:date_range => @ranges[:january_to_february], :other_records => [record1]})

      record2.should_not be_valid
      record2.errors.should == {:date_range => ["overlaps"]}
    end
    
    it "should be valid when overlapping nil" do
      record = TestModel.new({:date_range => @ranges[:january], :other_records => nil})
      record.should be_valid
    end
    
    it "should be valid when overlapping an empty set" do
      record = TestModel.new({:date_range => @ranges[:january], :other_records => []})
      record.should be_valid
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

  end

end
