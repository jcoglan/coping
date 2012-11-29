require 'erb'

module Coping
  module Formats
    
    class HTML
      def initialize(value)
        @value = value
      end
      
      def to_s
        ERB::Util.html_escape(@value.to_s)
      end
    end
    
  end
end

