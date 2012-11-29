module Coping
  class Compiler
    
    def self.compile(parse_tree)
      new(parse_tree).compile
    end
    
    def initialize(parse_tree)
      @parse_tree = parse_tree
    end
    
    def compile
      template = StringIO.new
      template.write("#{out} = #{init}\n")
      skip_newline = false
      @parse_tree.walk do |node, target_type|
        if node.is_a?(Grammar::TemplateInstruction)
          skip_newline = node.skip_newline?
          if node.output?
            template.write("#{tmp} = eval(#{node.source_code.inspect}, binding, #{filename.inspect}, 0)\n")
            output(template, target_type, skip_newline)
          else
            template.write(node.source_code)
            template.write("\n")
          end
        else          
          template.write("#{tmp} = #{node.text_value.inspect}\n")
          output(template, target_type, skip_newline)
        end
      end
      template.write(final.call(out))
      template.rewind
      template.read
    end
    
    def output(template, target_type, skip_newline)
      if skip_newline
        template.write("#{tmp} = #{tmp}.gsub(/\\s*\\n\\s*/, '')\n")
      end
      
      if target_type
        template.write("#{tmp} = Coping::Rules.convert(#{tmp}, :#{target_type})\n")
      end
      
      template.write("#{out}.#{write}(#{tmp})\n")
    end
    
  private
    
    def filename
      '(coping)'
    end
    
    def out
      '_out_'
    end
    
    def tmp
      '_tmp_'
    end
    
    def init
      'StringIO.new'
    end
    
    def write
      'write'
    end
    
    def final
      lambda { |o| "#{o}.rewind\n#{o}.read" }
    end
    
  end
end

