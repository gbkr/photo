module Photo
  class Backup

    def initialize(options={})
      @settings = options[:settings] || settings
      backup new_files
    end

    private

    def backup files      
      if files
        progress_bar = ProgressBar.create(:title => "Backup",
                                          :total => files.size, 
                                          :format => "%t %p%% |%B|#{files.size}")

        files.each { |file|
          backup_file file
          progress_bar.increment }
      end
    end

    def backup_file file
      filename = File.basename(file)
      backup_target = File.join(@settings[:backup], filename)
      FileUtils.cp(file, backup_target)
    end

    def new_files
      media = File.join("**", "*.{#{@settings[:photo_ext]},#{@settings[:video_ext]}}")
      source = Dir.glob("#{@settings[:source]}/#{media}")
      backup = Dir.glob("#{@settings[:backup]}/#{media}")
      source - backup
    end

    def settings
      YAML.load_file(Photo::Init::CONFIG_FILE)
    end
  end
end


