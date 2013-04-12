require 'spec_helper'

module Photo
  describe TimeFormatter do
    it 'displays seconds correctly' do
      Float(5).to_time_sentence.
        should == '5 seconds'
    end
  
    it 'displays seconds and minutes correctly' do
      Float(65).to_time_sentence.
        should == '1 minute and 5 seconds'
    end

    it 'displays hours and seconds correctly' do
      Float(3605).to_time_sentence.
        should == '1 hour and 5 seconds'
    end

    it 'displays hours, minutes and seconds correctly' do
      Float(3665.1).to_time_sentence.
        should == '1 hour, 1 minute and 5 seconds'
    end
  
    it 'displays microseconds correctly' do
      Float(0.0001).to_time_sentence.
        should == '0.0001 seconds'
    end
  end
end
