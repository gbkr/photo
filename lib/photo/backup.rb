module Photo
  class Backup < FileMover

    def initialize(output, options={})
      super
      check_backup_device_present
    end

    def backup
      display_and_time do
        backup_files new_files
      end
    end

    private

    def check_backup_device_present
      unless File.exists?(@settings[:backup])
        raise "\n Nothing found at #{@settings[:backup]}. Please check that your storage device is connected.\n".color(:red)
      end
    end

    def backup_files files
      if files.empty?
        @output.puts " Backup is up-to-date".color(:green)
      else
        process files
      end
    end

    def process files
      progress = progress_bar('Backing up media', files.size)
      files.each { |file|
        backup_file file
        progress.increment }
    end


    def backup_file file
      target = file.gsub(@settings[:target], @settings[:backup])
      dirname = File.dirname(target)   
      FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
      FileUtils.cp(file, target)
    end

    def new_files
      media = File.join("**", "*.{#{@settings[:photo_ext]},#{@settings[:video_ext]}}")
      target = Dir.glob("#{@settings[:target]}/#{media}")
      backup = Dir.glob("#{@settings[:backup]}/#{media}")
      target - backup.map { |filename| filename.gsub(@settings[:backup], @settings[:target]) }
    end
  end
end


