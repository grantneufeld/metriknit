# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metriknit/version'

Gem::Specification.new do |spec|
  spec.name = 'metriknit'
  spec.version = Metriknit::VERSION
  spec.author = 'Grant Neufeld'
  spec.email = 'activist@activist.ca'
  spec.description = 'Merge the results of various ruby code analysis (metrics) tools.'
  spec.summary = 'Merge code analysis results'
  spec.homepage = 'https://github.com/grantneufeld/metriknit'
  spec.license = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'json'
  spec.add_dependency 'bundler'
  spec.add_dependency 'rake'
  # metric gems used
  spec.add_dependency 'brakeman'
  spec.add_dependency 'cane'
  spec.add_dependency 'churn'
  #spec.add_dependency 'flay'
  spec.add_dependency 'flog'
  spec.add_dependency 'rails_best_practices'
  spec.add_dependency 'railties' # for the `rake notes` task and SourceAnnotationExtractor class, of all things
  spec.add_dependency 'reek'
  spec.add_dependency 'roodi'
  spec.add_dependency 'tailor'
end
