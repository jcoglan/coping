Gem::Specification.new do |s|
  s.name              = "coping"
  s.version           = "0.1.0"
  s.summary           = "Type-safe string composition"
  s.author            = "James Coglan"
  s.email             = "jcoglan@gmail.com"
  s.homepage          = "http://github.com/jcoglan/coping"

  s.extra_rdoc_files  = %w[README.rdoc]
  s.rdoc_options      = %w[--main README.rdoc]
  s.require_paths     = %w[lib]

  s.files = %w[README.rdoc] +
            Dir.glob("{examples,lib,spec}/**/*")
  
  s.add_dependency "treetop"
  
  s.add_development_dependency "rspec"
end

