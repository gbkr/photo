require 'spec_helper'

module Photo
  describe Fetch do

    let(:settings) { Photo::ConfigTestSetup::SETTINGS }
    let(:source) { settings[:settings][:source] }
    let(:target) { settings[:settings][:target] }
    let(:photo_ext) { settings[:settings][:photo_ext] }
    let(:video_ext) { settings[:settings][:video_ext] }
    let(:progress_bar) { ProgressBar.create(:output => File.open(File::NULL, 'w+')) }

    before(:each) do
      FileUtils.mkdir_p(source)
      FileUtils.mkdir_p(target)
      File.new("#{source}/file.#{photo_ext}", 'w+')
      File.new("#{source}/file.#{video_ext}", 'w+')
    end

    after(:each) do
      FileUtils.rm_rf(source)
      FileUtils.rm_rf(target)
    end

    after(:all) do
      FileUtils.rm_rf('tmp')
    end

    it 'should copy the files from source to target' do
      media = File.join("**", "*.{#{photo_ext},{#{video_ext}")
      initial_target_count = Dir.glob("#{target}/#{media}").size
      Photo::Fetch.new(STDOUT, settings).fetch
      source_count = Dir.glob("#{source}/#{media}").size
      final_target_count = Dir.glob("#{target}/#{media}").size
      final_target_count.should == initial_target_count + source_count
    end

    it 'should place photos into the photo directory' do
      check_path_for_media_type(photo_ext, 'Photos')
    end

    it 'should place videos into the video directory' do
      check_path_for_media_type(video_ext, 'Videos')
    end

    def check_path_for_media_type(extension, directory)
      Photo::Fetch.new(STDOUT, settings).fetch
      file = Dir.glob("#{target}/**/*.#{extension}").first
      d = Date.today
      path = "#{d.year}/#{d.strftime("%m %B")}/#{d.day}/#{directory}"
      file.should match(path)
    end

    it 'should notify the user if files are up-to-date' do
      output = double('output')
      output.should_receive(:puts).with(/[Photos|Video] are up-to-date/).twice
      Photo::Fetch.new(output, settings).fetch
      Photo::Fetch.new(output, settings).fetch
    end

    it 'should notify the user when no photos are found' do
      output = double('output')
      output.should_receive(:puts).with(/No photos found/)
      File.delete("#{source}/file.#{photo_ext}")
      Photo::Fetch.new(output, settings).fetch
    end

    it 'should notify the user when no videos are found' do
      output = double('output')
      output.should_receive(:puts).with(/No videos found/)
      File.delete("#{source}/file.#{video_ext}")
      Photo::Fetch.new(output, settings).fetch
    end

    it 'should raise an exception when camera not found' do
      settings[:settings][:source] = 'tmp/not_found_here'
      expect { 
        Photo::Fetch.new(STDOUT, settings)
      }.to raise_error(/Nothing found/)
    end
  end
end
