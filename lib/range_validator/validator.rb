require 'active_model'

module ActiveModel
  module Validations
    class RangeValidator < ActiveModel::EachValidator
      
      def validate_each(record, attribute, value)

        unless value.is_a? Range
           record.errors.add attribute, :not_a_range
           return
        end

        if options[:overlapping]
          record.send(options[:overlapping]).each do |other_record|
            record.errors.add attribute, :no_overlap if not OverlapDetector.overlap?(value, other_record.send(attribute))
          end
        end

        if options[:not_overlapping]
          record.send(options[:not_overlapping]).each do |other_record|
            record.errors.add attribute, :overlap if OverlapDetector.overlap?(value, other_record.send(attribute))
          end
        end

      end
      
    end
  end
end
