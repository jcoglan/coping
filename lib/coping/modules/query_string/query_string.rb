module Coping
  
  class QueryString < Raw
    Treetop.load(File.expand_path('../query_string_grammar.tt', __FILE__))
    
    def parser_class
      Grammar::QueryStringParser
    end
  end
  
  module Grammar
    module QueryStringText
      def walk(&block)
        if respond_to?(:pair)
          pair.key.walk(&block)
          block.call(pair.eq)
          pair.value.walk(&block)
          if rest.respond_to?(:amp)
            block.call(rest.amp)
            rest.query_string.walk(&block)
          end
        else
          block.call(self, :query_string)
        end
      end
    end
    
    module QueryStringValue
      def walk(&block)
        block.call(self, :query_string_value)
      end
    end
  end
  
end

