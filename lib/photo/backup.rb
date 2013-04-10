module Photo
  class Backup
   
    def initialize(options={})
      @settings = options[:settings] || settings
      perform_backup
    end

    private

    def perform_backup      
      files_to_backup.each do |file|
        # progress bar update goes here
        backup file
      end
    end

    def backup file
      filename = File.basename(file)
      backup_target = File.join(@settings[:backup], filename)
      FileUtils.cp(file, backup_target)
    end
    
    def files_to_backup
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


