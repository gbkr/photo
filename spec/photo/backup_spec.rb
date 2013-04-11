require 'spec_helper'

module Photo
  describe Backup do

    let(:settings) { Photo::ConfigTestSetup::SETTINGS }
    let(:target) { settings[:settings][:target] }
    let(:backup) { settings[:settings][:backup] }
    let(:photo_ext) { settings[:settings][:photo_ext] }
    let(:video_ext) { settings[:settings][:video_ext] }

    before(:each) do
      FileUtils.mkdir_p(target)
      FileUtils.mkdir_p(backup)
      File.new("#{target}/file1.#{photo_ext}", 'w+')
      File.new("#{target}/file2.#{photo_ext}", 'w+')
      File.new("#{target}/file3.#{video_ext}", 'w+')
      File.new("#{backup}/file1.#{photo_ext}", 'w+')
    end

    after(:each) do
      FileUtils.rm_rf(target)
      FileUtils.rm_rf(backup)
    end

    it 'should keep target files the same' do
      target_before = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      Photo::Backup.new(settings)
      target_after = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      target_before.should == target_after
    end

    it 'should synchronize target and backup' do
      Photo::Backup.new(settings)
      target_result = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      backup_result = Dir.glob("#{backup}/**/*.{#{photo_ext},#{video_ext}}")
      target_result.map {|e| File.basename(e)}.
        should == backup_result.map {|e| File.basename(e)}
    end
  end
end
