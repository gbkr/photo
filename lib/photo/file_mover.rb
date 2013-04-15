module Photo
  class FileMover
    def initialize(output, options={})
      @settings = options[:settings] || settings
      @output = output
      @stream = @settings.fetch(:progress_output, STDOUT)
    end

    def display_and_time
      start_time = Time.now
      @stream.puts
      yield
      @stream.puts "\n Finished in #{(Time.now - start_time).to_time_sentence}\n".color(:yellow)
    end

    def progress_bar(title, size)
      ProgressBar.create(:title => " #{title}",
                         :total => size, 
                         #:format => '%t |%B| (%C, %p%%)',
                         :format => "%t |%B| (#{size.to_s.rjust(4)}, %p%%)",
                         :progress_mark => '.',
                         :output => @settings[:progress_output])

    end


    def settings
      YAML.load_file(Photo::Init::CONFIG_FILE)
    end
  end
end
