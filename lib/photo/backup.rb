module Photo
  class Backup

    def initialize(options={})
      @settings = options[:settings] || settings
      puts ""
      t1 = Time.now
      backup new_files
      t2 = Time.now
      puts ""
      puts "Completed in #{t2-t1}s."
      puts ""
    end

    private

    def backup files      
      if files
        progress_bar = ProgressBar.create(:title => "Backing up media",
                                          :total => files.size, 
                                          :format => '%t |%B| (%C, %p%%)',
                                          :progress_mark => '.')

        files.each { |file|
          backup_file file
          progress_bar.increment }
      end
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

    def settings
      YAML.load_file(Photo::Init::CONFIG_FILE)
    end
  end
end


