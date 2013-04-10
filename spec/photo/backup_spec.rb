require 'spec_helper'

module Photo
  describe Backup do

    let(:settings) { Photo::ConfigTestSetup::SETTINGS }
    let(:source) { settings[:settings][:source] }
    let(:backup) { settings[:settings][:backup] }
    let(:photo_ext) { settings[:settings][:photo_ext] }
    let(:video_ext) { settings[:settings][:video_ext] }

    before(:each) do
      FileUtils.mkdir_p(source)
      FileUtils.mkdir_p(backup)
      File.new("#{source}/file1.#{photo_ext}", 'w+')
      File.new("#{source}/file2.#{photo_ext}", 'w+')
      File.new("#{source}/file3.#{video_ext}", 'w+')
      File.new("#{backup}/file1.#{photo_ext}", 'w+')
    end

    after(:each) do
      FileUtils.rm_rf(source)
      FileUtils.rm_rf(backup)
    end

    it 'should keep source files the same' do
      source_before = Dir.glob("#{source}/**/*.{#{photo_ext},#{video_ext}}")
      Photo::Backup.new(settings)
      source_after = Dir.glob("#{source}/**/*.{#{photo_ext},#{video_ext}}")
      source_before.should == source_after
    end

    it 'should synchronize source and backup' do
      Photo::Backup.new(settings)
      source_result = Dir.glob("#{source}/**/*.{#{photo_ext},#{video_ext}}")
      backup_result = Dir.glob("#{backup}/**/*.{#{photo_ext},#{video_ext}}")
      source_result.map {|e| File.basename(e)}.
        should == backup_result.map {|e| File.basename(e)}
    end
  end
end
