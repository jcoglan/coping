require 'cgi'

module Coping
  module Rules
    
    @rules = Hash.new { |h,k| h[k] = {} }
    
    def self.define(data_type, target_type, &block)
      @rules[data_type][target_type] = block
    end
    
    def self.convert(value, target_type)
      types = @rules[target_type]
      match = types.keys.find { |k| value.is_a?(k) }
      block = types[match]
      return value unless block
      block.call(value)
    end
    
    define :query_string_value, Object do |value|
      Formats::CGI::Value.new(value)
    end
    
    define :query_string, Hash do |value|
      Formats::CGI::Map.new(value)
    end
    
  end
end

