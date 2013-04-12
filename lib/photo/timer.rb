module Photo
  module Timer
    def display_and_time
      start_time = Time.now
      puts ""
      yield
      puts "\nFinished in #{(Time.now - start_time).to_time_sentence}\n"
    end
  end
end
