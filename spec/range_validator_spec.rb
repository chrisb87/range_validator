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
    model = TestModel.new({:name => "name"})

    model.should_not be_valid
    model.errors.should == {:name => ["is not a range"]}
  end

  context "overlapping_with" do
    
    before(:each) do
      TestModel.validates :date_range, :range => { :overlapping => :other_models }
    end
    
    it "should be valid when there is overlap" do
      model1 = TestModel.new({:date_range => @ranges[:january]})
      model2 = TestModel.new({:date_range => @ranges[:january_to_february], :other_models => [model1]})

      model2.should be_valid
    end
    
    it "should not be valid when there is no overlap" do
      model1 = TestModel.new({:date_range => @ranges[:january]})
      model2 = TestModel.new({:date_range => @ranges[:february], :other_models => [model1]})

      model2.should_not be_valid
      model2.errors.should == {:date_range => ["does not overlap"]}
    end
    
  end

  context "not_overlapping_with" do
    
    before(:each) do
      TestModel.validates :date_range, :range => { :not_overlapping => :other_models }
    end

    it "should be valid when there is no overlap" do
      model1 = TestModel.new({:date_range => @ranges[:january]})
      model2 = TestModel.new({:date_range => @ranges[:february], :other_models => [model1]})

      model2.should be_valid
    end

    it "should not be valid when there is an overlap" do
      model1 = TestModel.new({:date_range => @ranges[:january]})
      model2 = TestModel.new({:date_range => @ranges[:january_to_february], :other_models => [model1]})

      model2.should_not be_valid
      model2.errors.should == {:date_range => ["overlaps"]}
    end

  end

end
