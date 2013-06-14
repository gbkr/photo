module Photo
  class Fetch < FileMover

    def initialize(output, options={})
      super
      check_camera_present
    end

    def fetch
      @stream.puts "\n Fetching media from camera\n"
      display_and_time do
        source_photos
        source_videos
      end
    end

    private

    def check_camera_present
      unless File.exists?(@settings[:source])
        raise "\n Nothing found at #{@settings[:source]}. Please check that your camera or memory card is connected.\n".color(:red)
      end
    end

    def fetch_files media, media_type
      if media.any?
      new_files = filter_duplicated media, media_type
        if new_files.empty?
          notify_files_up_to_date media_type
        else
          copy_files new_files, media_type
        end
      else
        notify_files_not_found media_type
      end
    end

    def source_photos
      photos = source_files_with_ext @settings[:photo_ext]
      fetch_files(photos, 'Photos')
    end

    def source_videos
      videos = source_files_with_ext @settings[:video_ext]
      fetch_files(videos, 'Videos')
    end

    def source_files_with_ext extension
      Dir.glob("#{@settings[:source]}/**/*.#{extension}")
    end


    def filter_duplicated media, media_type
      target_paths = {}
      media.each do |file|
        target_path = File.join(@settings[:target], folder_name_for(file, media_type), File.basename(file))
        target_paths[file] = target_path unless File.exists?(target_path)
      end
      target_paths
    end 

    def copy_files media, media_type
      progress = progress_bar(media_type, media.size)
      media.each { |file, destination|
        fetch_file(file, destination)
        progress.increment }
    end

    def notify_files_up_to_date media_type
      @output.puts " #{media_type} are up-to-date".color(:green)
    end

    def notify_files_not_found media_type
      @output.puts " No #{media_type.downcase} found"
    end

    def fetch_file(file, destination)
      dirname = File.dirname(destination)
      FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
      FileUtils.cp(file, destination)
    end

    def folder_name_for file, media_type
      ctime = File.open(file) { |f| Date.parse(f.ctime.to_s) }
      "#{ctime.year.to_s}/#{ctime.strftime('%m %B')}/#{ctime.strftime('%e')}/#{media_type}"
    end
  end
end
