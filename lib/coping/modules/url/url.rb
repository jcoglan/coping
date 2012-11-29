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
      def walk(encodings = [], &block)
        %w[scheme host port path].each do |part|
          value = __send__(part)
          if value.respond_to?(:walk)
            value.walk(encodings, &block)
          elsif value.text_value != ''
            block.call(value)
          end
        end
        unless query.text_value == ''
          block.call(query.q)
          query.query_string.walk(encodings, &block) if query.query_string.respond_to?(:walk)
        end
        block.call(hash) unless hash.text_value == ''
      end
    end
    
    module URLScheme
      def walk(encodings = [], &block)
        block.call(name)
        block.call(colon)
      end
    end
    
    module URLDomain
      def walk(encodings = [], &block)
        block.call(slash)
        block.call(domain)
      end
    end
    
    module URLPort
      def walk(encodings = [], &block)
        block.call(colon)
        block.call(number)
      end
    end
  end
  
end

