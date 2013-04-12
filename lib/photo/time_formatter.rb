module Photo
  module TimeFormatter
    require 'ostruct'

    def to_time_sentence
      sentence_from float_time
    end

    private

    def float_time(seconds=self.to_i)
      hours = seconds / 3600
      seconds -= (3600 * hours)
      minutes = seconds / 60
      seconds -= (60 * minutes)
      OpenStruct.new(hours: hours, minutes: minutes, seconds: seconds)
    end 
 
    def sentence_from(time)
      sentence = ""

      if time.hours > 0
        hours = time.hours > 1 ? 'hours' : 'hour'
        sentence << "#{time.hours} #{hours}"
      end

      if time.minutes > 0
        sentence << deliminator(time)
        minutes = time.minutes > 1 ? 'minutes' : 'minute'
        sentence << "#{time.minutes} #{minutes}"
      end

      if time.seconds > 0
        sentence << ' and ' unless sentence.empty?
        seconds = time.seconds > 1 ? 'seconds' : 'second'
        sentence << "#{time.seconds} #{seconds}"
      elsif time.hours == 0 and time.minutes == 0
        sentence << "#{self.round(4)} seconds"
      end

      sentence
    end


    def deliminator(time)
      if time.hours > 0 and time.seconds > 0
        ', '
      elsif time.hours > 0
        ' and '
      else
        ''
      end
    end
  end
end
