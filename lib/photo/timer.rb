module Photo
  module Timer
    def display_and_time(stream)
      start_time = Time.now
      stream.puts ""
      yield
      stream.puts "\nFinished in #{(Time.now - start_time).to_time_sentence}\n"
    end
  end
end
