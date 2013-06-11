# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','photo','version.rb'])
Gem::Specification.new do |s| 
  s.name = 'photo'
  s.version = Photo::VERSION
  s.author = 'Greg Baker'
  s.email = 'gba311 at gmail.com'
  s.homepage = ''
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command line utility to retrieve, categorize, store and backup media from a digital camera.'
  s.files = %w(
    bin/photo
    lib/photo/version.rb
    lib/photo/init.rb
    lib/photo/file_mover.rb
    lib/photo/time_formatter.rb
    lib/photo/backup.rb
    lib/photo/fetch.rb
    lib/photo.rb 
  )
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables << 'photo'
  s.add_development_dependency('rake')
  s.add_development_dependency('thor')
  s.add_runtime_dependency('rainbow')
  s.add_runtime_dependency('ruby-progressbar')
end
