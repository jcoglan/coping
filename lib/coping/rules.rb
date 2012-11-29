require 'cgi'

module Coping
  module Rules
    
    @rules = Hash.new { |h,k| h[k] = {} }
    
    def self.define(data_type, target_type, &block)
      @rules[data_type][target_type] = block
    end
    
    def self.convert(value, encodings)
      encodings.inject(value) do |wrapper, encoding|
        types = @rules[encoding]
        match = types.keys.find { |k| value.is_a?(k) }
        block = types[match]
        return value unless block
        block.call(wrapper)
      end
    end
    
    define :query_string_value, Object do |value|
      Formats::CGI::Value.new(value)
    end
    
    define :query_string, Hash do |value|
      Formats::CGI::Map.new(value)
    end
    
    define :html, Object do |value|
      Formats::HTML.new(value)
    end
    
  end
end

