module Coping
  
  class Raw
    Treetop.load(File.expand_path('../raw_grammar.tt', __FILE__))
    
    def initialize(source)
      @source = source
    end
    
    def parser
      @parser ||= parser_class.new
    end
    
    def parser_class
      Grammar::RawParser
    end
    
    def result(env = TOPLEVEL_BINDING)
      eval(template, env, '(coping)', 0)
    end
    
  private
    
    def template
      @template ||= Compiler.compile(parser.parse(@source))
    end
  end
  
  module Grammar
    module RawText
      def walk(&block)
        elements.each(&block)
      end
    end
    
    module TemplateInstruction
      def flag_names
        return [] unless flags.respond_to?(:first)
        names = [flags.first.text_value]
        flags.rest.elements.each do |f|
          names << f.flag.text_value
        end
        names
      end
      
      def output?
        flag_names.include?('=')
      end
      
      def skip_newline?
        close.flags.text_value == '-'
      end
      
      def source_code
        code.text_value.strip
      end
    end
  end
  
end

