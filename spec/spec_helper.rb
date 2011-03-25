require 'ostruct'
require 'active_model'

class TestModel < OpenStruct
  include ActiveModel::Validations
end

