require 'stringio'
require 'treetop'

module Coping
  ROOT = File.expand_path('..', __FILE__)
  
  module Grammar
  end
  
  autoload :Compiler, ROOT + '/coping/compiler'
  autoload :Raw,      ROOT + '/coping/modules/raw/raw'
end

