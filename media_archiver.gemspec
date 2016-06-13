# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'media_archiver/version'

Gem::Specification.new do |spec|
  spec.name          = 'media_archiver'
  spec.version       = MediaArchiver::VERSION
  spec.authors       = ['David Ramalho']
  spec.email         = ['david@ragingnexus.com']
  spec.summary       = 'Utility to organize media files based on metadata'
  spec.description   = 'Utility that scans a given location for media files and,
  based on Exif information and a set of rules copies the files over to
  another location.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'byebug'

  spec.add_dependency 'mini_exiftool'
  spec.add_dependency 'thor'
end
