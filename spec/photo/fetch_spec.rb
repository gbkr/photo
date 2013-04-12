require 'spec_helper'

module Photo
  describe Fetch do

    let(:settings) { Photo::ConfigTestSetup::SETTINGS }
    let(:source) { settings[:settings][:source] }
    let(:target) { settings[:settings][:target] }
    let(:photo_ext) { settings[:settings][:photo_ext] }
    let(:video_ext) { settings[:settings][:video_ext] }

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

    it 'should copy the files from source to target' do
      media = File.join("**", "*.{#{photo_ext},{#{video_ext}")
      initial_target_count = Dir.glob("#{target}/#{media}").size
      Photo::Fetch.new(STDOUT, settings)
      source_count = Dir.glob("#{source}/#{media}").size
      final_target_count = Dir.glob("#{target}/#{media}").size
      final_target_count.should == initial_target_count + source_count
    end

    it 'should place photos into the photo directory' do
      check_path_for_media_type(photo_ext, 'photos')
    end

    it 'should place videos into the video directory' do
      check_path_for_media_type(video_ext, 'videos')
    end

    def check_path_for_media_type(extension, directory)
      Photo::Fetch.new(STDOUT, settings)
      file = Dir.glob("#{target}/**/*.#{extension}").first
      d = Date.today
      path = "#{d.year}/#{d.strftime("%m %B")}/#{d.day}/#{directory}"
      file.should match(path)
    end

    it 'should notify the user if files are up-to-date' do
      output = double('output')
      output.should_receive(:puts).with(/[Photos|Video] are up-to-date/).twice
      Photo::Fetch.new(output, settings)
      Photo::Fetch.new(output, settings)
    end
  end
end
