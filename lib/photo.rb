require 'photo/version'
require 'photo/init'
require 'photo/file_mover'
require 'photo/backup'
require 'photo/fetch'
require 'photo/time_formatter'
require 'photo/timer'

require 'yaml'
require 'fileutils'
require 'date'

require 'ruby-progressbar'

class Float
  include Photo::TimeFormatter
end

