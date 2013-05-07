# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','photo','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'photo'
  s.version = Photo::VERSION
  s.author = 'Greg Baker'
  s.email = 'gba311 at gmail.com'
  s.homepage = ''
  s.platform = Gem::Platform::RUBY
  s.summary = 'Retrieve, store and backup photos from your digital camera.'
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
  #s.extra_rdoc_files = ['README.rdoc','photo.rdoc']
  #s.rdoc_options << '--title' << 'photo' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'photo'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  #s.add_development_dependency('aruba')
  s.add_runtime_dependency('rainbow')
  s.add_runtime_dependency('ruby-progressbar')
  s.add_runtime_dependency('gli','2.5.6')
end
