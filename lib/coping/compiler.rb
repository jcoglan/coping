module Coping
  class Compiler
    
    OUTVAR  = '_out_'
    TEMPVAR = '_tmp_'
    OUTINIT = 'StringIO.new'
    WRITE   = 'write'
    FINAL   = lambda { |o| "#{o}.rewind\n#{o}.read" }
    
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
      @parse_tree.elements.each do |node|
        case node
        when Grammar::RawString
          template.write("#{tmp} = #{node.text_value.inspect}\n")
          template.write("#{tmp} = #{tmp}.gsub(/\\s*\\n\\s*/, '')\n") if skip_newline
          template.write("#{out}.#{write}(#{tmp})\n")
        when Grammar::TemplateInstruction
          skip_newline = node.skip_newline?
          if node.output?
            template.write("#{tmp} = eval(#{node.code.text_value.strip.inspect}, binding, '(coping)', 0)\n")
            template.write("#{tmp} = #{tmp}.gsub(/\\s*\\n\\s*/, '')\n") if skip_newline
            template.write("#{out}.#{write}(#{tmp})\n")
          else
            template.write(node.code.text_value.strip)
            template.write("\n")
          end
        end
      end
      template.write(FINAL.call(out))
      template.rewind
      template.read
    end
    
  private
    
    def out
      OUTVAR
    end
    
    def tmp
      TEMPVAR
    end
    
    def init
      OUTINIT
    end
    
    def write
      WRITE
    end
    
  end
end

