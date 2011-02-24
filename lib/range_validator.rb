require 'active_model'
require 'active_support/core_ext'
require 'active_support/i18n'

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]

module ActiveModel

  # == Active Model Range Validator
  module Validations
    class RangeValidator < ActiveModel::EachValidator
      OPTIONS = [:overlapping, :not_overlapping].freeze

      def check_validity!
        options.each do |option, option_value|
          next if option_value.is_a?(Symbol) || option_value.is_a?(Proc)
          raise ArgumentError, ":#{option} must be a symbol or a proc"
        end
      end

      def validate_each(record, attribute, value)
        unless value.is_a? Range
          record.errors.add(attribute, :not_a_range)
          return
        end

        options.slice(*OPTIONS).each do |option, option_value|
          other_records = retrieve_other_records(record, option_value)

          if option == :overlapping && other_records.blank?
            record.errors.add(attribute, :no_overlap)
          end

          other_records.each do |other_record|
            overlap = value.overlaps? other_record.send(attribute)

            if option == :overlapping && !overlap
              record.errors.add(attribute, :no_overlap)
            elsif option == :not_overlapping && overlap
              record.errors.add(attribute, :overlap)
            end
          end
        end
      end

      protected

        def retrieve_other_records(record, lookup)
          if lookup.is_a?(Symbol)
            other_records = record.send(lookup)
          elsif lookup.is_a?(Proc)
            other_records = lookup.call(record)
          end

          responds_to_key = record.respond_to?(:to_key) && !record.to_key.blank?

          (other_records || []).reject do |other_record| 
            other_record.equal?(record) || (responds_to_key && other_record.to_key == record.to_key)
          end
        end
      end

    module HelperMethods
      # Validates that the specified attributes are valid ranges and, optionally, that they do
      # or do not overlap with ranges in other models. Examples:
      #
      #   validates :field, :range => true
      #   validates :field, :range => { :overlapping => Proc.new{ |record| record.other_records } }
      #   validates :field, :range => { :not_overlapping => :other_records }
      #
      # When passing a symbol to :overlapping or :not_overlapping, the object must respond_to that
      # message with a (possibly empty) list of objects that have the same fields.
      #
      def validates_range_of(*attr_names)
        validates_with RangeValidator, _merge_attributes(attr_names)
      end
    end
  end
end
