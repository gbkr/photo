module Photo
  class Fetch

    def initialize(options={})
      @settings = options[:settings] || settings
      fetch_photos
      fetch_videos
    end

    private

    def fetch_photos
      source_photos.each.with_index do |photo, i|
        # todo: show progess using i
        fetch_file photo
      end
    end 

    def fetch_videos
      source_videos.each.with_index do |video, i|
        # todo: show progress with i 
        fetch_file video
      end
    end

    def source_photos
      Dir.glob("#{@settings[:source]}/**/*.#{@settings[:photo_ext]}")
    end

    def source_videos
      Dir.glob("#{@settings[:source]}/**/*.#{@settings[:video_ext]}")
    end

    def fetch_file(file)
      target_location = File.join(@settings[:target], folder_name_for(file))
      FileUtils.mkdir_p(target_location) unless File.exists?(target_location)
      FileUtils.cp(file, target_location) 
    end

    def folder_name_for file
      ctime = File.open(file) { |f| Date.parse(f.ctime.to_s) }
      "#{ctime.year.to_s}/#{ctime.strftime('%m %B')}/#{ctime.strftime('%e')}/#{media_type(file)}"
    end


    def media_type(file)
      File.extname(file) == ".#{@settings[:photo_ext]}" ? 'photos' : 'videos'
    end

    def settings
      YAML.load(Photo::Init::CONFIG_FILE)
    end
  end
end
