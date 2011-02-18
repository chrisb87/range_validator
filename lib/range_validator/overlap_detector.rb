module ActiveModel
  module Validations
    class RangeValidator
      module OverlapDetector
        
        def self.overlap(range1, range2)
          min, max = range1.first, range1.exclude_end? ? range1.max : range1.last
          other_min, other_max = range2.first, range2.exclude_end? ? range2.max : range2.last

          new_min = range1 === other_min ? other_min : range2 === min ? min : nil
          new_max = range1 === other_max ? other_max : range2 === max ? max : nil

          new_min && new_max ? new_min..new_max : nil
        end

        def self.overlap?(range1, range2)
          overlap(range1, range2) ? true : false
        end
        
      end
    end
  end
end
