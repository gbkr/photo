require 'photo/version'
require 'photo/init'
require 'photo/file_mover'
require 'photo/backup'
require 'photo/fetch'
require 'photo/time_formatter'

require 'yaml'
require 'fileutils'
require 'date'

require 'ruby-progressbar'
require 'rainbow'

class Float
  include Photo::TimeFormatter
end

