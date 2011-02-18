require 'spec_helper'
require 'range_validator'

describe "RangeValidator::OverlapDetector" do
  range = 5..10
  tests = {
    1..4   => nil,     # before
    11..15 => nil,     # after
    1..6   => 5..6,    # overlap_begin
    9..15  => 9..10,   # overlap_end
    1..5   => 5..5,    # overlap_begin_edge
    10..15 => 10..10,  # overlap_end_edge
    5..10  => 5..10,   # overlap_all
    6..9   => 6..9,    # overlap_inner

    1...5  => nil,     # before (exclusive range)
    1...7  => 5..6,    # overlap_begin (exclusive range)
    1...6  => 5..5,    # overlap_begin_edge (exclusive range)
    5...11 => 5..10,   # overlap_all (exclusive range)
    6...10 => 6..9,    # overlap_inner (exclusive range)
  }

  tests.each do |other_range, expected|
    it "should detect the overlap of #{range} and #{other_range} as #{expected.inspect}" do
      ActiveModel::Validations::RangeValidator::OverlapDetector.overlap(range, other_range).should == expected
    end
  end
end
