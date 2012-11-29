require 'cgi'

module Coping
  module Formats
    module CGI
      
      class Value
        def initialize(value)
          @value = value
        end
        
        def to_s
          ::CGI.escape(@value.to_s)
        end
      end
      
      class Map
        def initialize(value)
          @value = value
        end
        
        def to_s
          return @value.to_s unless @value.is_a?(Hash)
          
          pairs = []
          each_qs_param('', @value) do |key, value|
            pairs << [key, value]
          end
          pairs.map { |p| p.join('=') }.join('&')
        end
        
      private
        
        def each_qs_param(prefix, value, &block)
          case value
          when Array
            value.each { |e| each_qs_param(prefix + '[]', e, &block) }
          when Hash
            value.each do |k,v|
              key = (prefix == '') ? ::CGI.escape(k.to_s) : prefix + "[#{::CGI.escape k.to_s}]"
              each_qs_param(key, v, &block)
            end
          else
            block.call(prefix, ::CGI.escape(value.to_s))
          end
        end
      end
      
    end
  end
end

