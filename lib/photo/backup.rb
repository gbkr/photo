module Photo
  class Backup < FileMover

    def initialize(output, options={})
      super
    end

    def backup
      display_and_time do
        backup_files new_files
      end
    end

    private

    def backup_files files
      if files.empty?
        @output.puts "Backup is up-to-date"
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
      unless File.exists?(target)
        path = target.split('/')[0..-2].join('/')
        FileUtils.mkdir_p(path)
        FileUtils.cp(file, target)
      end 
    end

    def new_files
      media = File.join("**", "*.{#{@settings[:photo_ext]},#{@settings[:video_ext]}}")
      target = Dir.glob("#{@settings[:target]}/#{media}")
      backup = Dir.glob("#{@settings[:backup]}/#{media}")
      target - backup.map { |filename| filename.gsub(@settings[:backup], @settings[:target]) }
    end
  end
end


