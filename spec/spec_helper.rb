$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ostruct'
require 'active_model'

class TestModel < OpenStruct
  include ActiveModel::Validations
end
