module Photo
  module TimeFormatter

    def to_time_sentence
      sentence_from float_time
    end

    private

    def float_time(seconds=self.to_i)
      hours = seconds / 3600
      seconds -= (3600 * hours)
      minutes = seconds / 60
      seconds -= (60 * minutes)
      {hour: hours, minute: minutes, second: seconds}
    end 

    def sentence_from(time)
      parts = sentence_parts(time)
      return "#{self.round(4)} seconds" if parts.none?
      return "#{parts[0]}" if parts.size == 1
      return parts.join(' and ') if parts.size == 2
      "#{parts[0]}, #{parts[1]} and #{parts[2]}"
    end

    def sentence_parts(time)
      time.map { |unit, value| plurality(unit, value) }.compact
    end

    def plurality(key, value)
      return if value == 0
      value < 2 ? "#{value} #{key}" : "#{value} #{key}s"
    end
  end
end
