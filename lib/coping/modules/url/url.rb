module Coping
  
  class URL < Raw
    require File.expand_path('../../query_string/query_string', __FILE__)
    Treetop.load(File.expand_path('../url_grammar.tt', __FILE__))
    
    def parser_class
      Grammar::URLParser
    end
  end
  
  module Grammar
    module URLText
      def walk(&block)
        %w[scheme host port path].each do |part|
          value = __send__(part)
          block.call(value.extend(RawString)) unless value.text_value == ''
        end
        unless query.text_value == ''
          block.call(query.elements.first.extend(RawString))
          query.query_string.walk(&block) if query.query_string.respond_to?(:walk)
        end
        h = hash
        block.call(h.extend(RawString)) unless h.text_value == ''
      end
    end
  end
  
end

