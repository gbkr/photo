module Photo
  module TimeFormatter

    def to_time_sentence 
      deliminate sentence_parts(float_to_time)
    end

    private

    def deliminate(parts)
      case parts.size
      when 0 then "#{self.round(4)} seconds" 
      when 1 then "#{parts[0]}" 
      when 2 then parts.join(' and ')
      else 
        "#{parts[0]}, #{parts[1]} and #{parts[2]}"
      end
    end

    def sentence_parts(time)
      time.map { |unit, value| plurality(unit, value) }.compact
    end

    def float_to_time(seconds=self.to_i)
      hours = seconds / 3600
      seconds -= (3600 * hours)
      minutes = seconds / 60
      seconds -= (60 * minutes)
      {hour: hours, minute: minutes, second: seconds}
    end 

    def plurality(key, value)
      return if value == 0
      value < 2 ? "#{value} #{key}" : "#{value} #{key}s"
    end
  end
end
