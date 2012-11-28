require 'cgi'

module Coping
  module Rules
    
    @rules = Hash.new { |h,k| h[k] = {} }
    
    def self.define(data_type, target_type, &block)
      @rules[data_type][target_type] = block
    end
    
    def self.convert(value, target_type)
      block = @rules[value.class][target_type]
      return value unless block
      block.call(value)
    end
    
    define String, :query_string_value do |value|
      CGI.escape(value)
    end
    
  end
end

