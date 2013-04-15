module Photo
  class FileMover
    def initialize(output, options={})
      @settings = options[:settings] || settings
      @output = output
      @stream = @settings.fetch(:progress_output, STDOUT)
    end

    def display_and_time
      start_time = Time.now
      @stream.puts ""
      yield
      @stream.puts "\nFinished in #{(Time.now - start_time).to_time_sentence}\n\n"
    end

    def progress_bar(title, size)
      ProgressBar.create(:title => "  #{title}",
                         :total => size, 
                         :format => '%t |%B| (%C, %p%%)',
                         :progress_mark => '.',
                         :output => @settings[:progress_output])

    end


    def settings
      YAML.load_file(Photo::Init::CONFIG_FILE)
    end
  end
end
