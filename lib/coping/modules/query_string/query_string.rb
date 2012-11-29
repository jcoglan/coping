module Coping
  
  class QueryString < Raw
    Treetop.load(File.expand_path('../query_string_grammar.tt', __FILE__))
    
    def parser_class
      Grammar::QueryStringParser
    end
  end
  
  module Grammar
    module QueryStringText
      def walk(encodings = [], &block)
        if respond_to?(:pair)
          pair.key.walk(encodings, &block)
          block.call(pair.eq)
          pair.value.walk(encodings, &block)
          if rest.respond_to?(:amp)
            block.call(rest.amp)
            rest.query_string.walk(encodings, &block)
          end
        else
          block.call(self, [:query_string] + encodings)
        end
      end
    end
    
    module QueryStringValue
      def walk(encodings = [], &block)
        block.call(self, [:query_string_value] + encodings)
      end
    end
  end
  
end

