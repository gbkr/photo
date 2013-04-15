require 'spec_helper'

module Photo
  describe Backup do

    let(:settings) { Photo::ConfigTestSetup::SETTINGS }
    let(:target) { settings[:settings][:target] }
    let(:backup) { settings[:settings][:backup] }
    let(:photo_ext) { settings[:settings][:photo_ext] }
    let(:video_ext) { settings[:settings][:video_ext] }

    let(:target_test_path) { "#{target}/date/media_type" }
    let(:backup_test_path) { "#{backup}/date/media_type" }


    before(:each) do
      FileUtils.mkdir_p(target)
      FileUtils.mkdir_p(backup)
      FileUtils.mkdir_p(target_test_path)
      FileUtils.mkdir_p(backup_test_path)

      File.new("#{target_test_path}/file1.#{photo_ext}", 'w+')
      File.new("#{target_test_path}/file2.#{photo_ext}", 'w+')
      File.new("#{target}/file3.#{video_ext}", 'w+')

      File.new("#{backup_test_path}/file1.#{photo_ext}", 'w+')
    end

    after(:each) do
      FileUtils.rm_rf(target)
      FileUtils.rm_rf(backup)
    end

    it 'should keep target files the same' do
      target_before = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      Photo::Backup.new(STDOUT, settings).backup
      target_after = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      target_before.should == target_after
    end

    it 'should synchronize target and backup' do
      Photo::Backup.new(STDOUT, settings).backup
      target_result = Dir.glob("#{target}/**/*.{#{photo_ext},#{video_ext}}")
      backup_result = Dir.glob("#{backup}/**/*.{#{photo_ext},#{video_ext}}")
      target_result.map { |e| e.gsub(target, backup) }.
      should == backup_result
    end

    it 'should notify the user when backups are up-to-date' do
      output = double('output')
      output.should_receive(:puts).with(/Backup is up-to-date/)
      Photo::Backup.new(STDOUT, settings).backup
      Photo::Backup.new(output, settings).backup
    end
  end
end
