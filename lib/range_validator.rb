require 'active_support/i18n'
I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]

require 'range_validator/validator'
require 'range_validator/overlap_detector'
