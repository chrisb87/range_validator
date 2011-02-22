require 'active_model'
require 'active_support'

module ActiveModel
  module Validations

    # == Active Model Range Validator
    class RangeValidator < ActiveModel::EachValidator
      OPTIONS = [:overlapping, :not_overlapping].freeze

      def check_validity!
        options.each do |option, option_value|
          next if option_value.is_a?(Symbol) || option_value.is_a?(Proc)
          raise ArgumentError, ":#{option} must be a Symbol or a Proc"
        end
      end

      def validate_each(record, attribute, value)
        unless value.is_a? Range
          record.errors.add attribute, :not_a_range
          return
        end

        options.slice(*OPTIONS).each do |option, option_value|
          if option_value.is_a?(Symbol)
            other_records = record.send(option_value)
          elsif option_value.is_a?(Proc)
            other_records = option_value.call(record)
          end

          other_records.reject!{ |other_record| other_record.equal? record }

          if record.respond_to?(:to_key) and not record.to_key.blank?
            other_records.reject!{ |other_record| other_record.to_key == record.to_key }
          end

          other_records.each do |other_record|
            overlap = OverlapDetector.overlap? value, other_record.send(attribute)

            if option == :overlapping and not overlap
              record.errors.add attribute, :no_overlap
            elsif option == :not_overlapping and overlap
              record.errors.add attribute, :overlap
            end
          end
        end
      end
    end
  end
end
