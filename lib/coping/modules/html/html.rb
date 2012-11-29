module Coping
  
  class HTML < Raw
    URL_ATTRIBUTES = %w[action href src]
    
    require File.expand_path('../../url/url', __FILE__)
    Treetop.load(File.expand_path('../html_grammar.tt', __FILE__))
    
    def parser_class
      Grammar::HTMLParser
    end
  end
  
  module Grammar
    module HTMLText
      def walk(encodings = [], &block)
        elements.each { |e| e.walk(encodings, &block) }
      end
    end
    
    module HTMLTemplateInstruction
      include TemplateInstruction
      def walk(encodings = [], &block)
        block.call(self, encodings + [:html])
      end
    end
    
    module HTMLDoctypeTag
      def walk(encodings = [], &block)
        block.call(o)
        block.call(attributes) # TODO dig
        block.call(c)
      end
    end
    
    module HTMLCommentTag
      def walk(encodings = [], &block)
        block.call(o)
        block.call(b) # TODO dig
        block.call(c)
      end
    end
    
    module HTMLOpeningTag
      def walk(encodings = [], &block)
        block.call(o)
        b.walk(encodings, &block)
        block.call(c)
      end
    end
    
    module HTMLClosingTag
      def walk(encodings = [], &block)
        block.call(o)
        name.walk(encodings, &block)
        block.call(c)
      end
    end
    
    module HTMLTagContents
      def walk(encodings = [], &block)
        name.walk(encodings, &block)
        attributes.elements.each do |e|
          block.call(e.elements.first)
          e.attr.walk(encodings, &block)
        end
      end
    end
    
    module HTMLTagName
      def walk(encodings = [], &block)
        block.call(self)
      end
    end
    
    module HTMLTagAttribute
      def walk(encodings = [], &block)
        block.call(name) # TODO dig
        block.call(eq)
        block.call(value.o) if value.respond_to?(:o)
        body = value.respond_to?(:b) ? value.b : value
        body.attribute_name = name.text_value
        body.walk(encodings, &block)
        block.call(value.c) if value.respond_to?(:c)
      end
    end
    
    module HTMLAttributeText
      attr_accessor :attribute_name
      
      def walk(encodings = [], &block)
        if Coping::HTML::URL_ATTRIBUTES.include?(attribute_name)
          url = Coping::URL.new(text_value)
          url.walk(encodings + [:html], &block)
        else
          elements.each do |element|
            block.call(element, encodings + [:html])
          end
        end
      end
    end
    
    module HTMLTextNode
      def walk(encodings = [], &block)
        block.call(self)
      end
    end
  end
  
end

