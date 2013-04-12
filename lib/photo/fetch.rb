module Photo
  require 'photo/timer'

  class Fetch
    include Photo::Timer

    def initialize(output, options={})
      @settings = options[:settings] || settings
      @output = output
      display_and_time do
        fetch source_photos
        fetch source_videos
      end
    end

    private

    def fetch media
      if media
        if files_up_to_date? media
          notify_files_up_to_date media_type(media.first).capitalize
        else
          copy_files media  
        end
      end
    end

    def copy_files media
      progress_bar = ProgressBar.create(:title => media_type(media.first).capitalize, 
                                        :total => media.size, 
                                        :format => '%t |%B| (%C, %p%%)',
                                        :progress_mark => '.')
      media.each { |file|
        fetch_file file
        progress_bar.increment }

    end

    def notify_files_up_to_date media_type
      @output.puts "#{media_type} are up-to-date"
    end

    def files_up_to_date? media
      source_target_hash(media).empty?
    end

    def source_target_hash media
      target_paths = {}
      media.each do |file|
         target_path =  File.join(@settings[:target], folder_name_for(file))
         target_paths[:file] = target_path unless File.exists?(target_path)
       end
      target_paths
    end

    def source_photos
      source_files_with_ext @settings[:photo_ext]
    end

    def source_videos
      source_files_with_ext @settings[:video_ext]
    end

    def source_files_with_ext extension
      Dir.glob("#{@settings[:source]}/**/*.#{extension}")
    end

    def fetch_file file
      target_location = File.join(@settings[:target], folder_name_for(file))
      unless File.exists?(File.join(target_location, file))
        FileUtils.mkdir_p(target_location)
        FileUtils.cp(file, target_location)  
      end
    end

    def folder_name_for file
      ctime = File.open(file) { |f| Date.parse(f.ctime.to_s) }
      "#{ctime.year.to_s}/#{ctime.strftime('%m %B')}/#{ctime.strftime('%e')}/#{media_type(file)}"
    end

    def media_type file
      File.extname(file) == ".#{@settings[:photo_ext]}" ? 'photos' : 'videos'
    end

    def settings
      YAML.load_file(Photo::Init::CONFIG_FILE)
    end
  end
end
