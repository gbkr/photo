require 'yaml'
require 'spec_helper'

module Photo
  describe Init do
    before(:all) do
      if File.exists?(Photo::Init::CONFIG_FILE)
        File.rename(Photo::Init::CONFIG_FILE, "#{Photo::Init::CONFIG_FILE}.bak")
      end
    end
    
    after(:all) do
      File.unlink(Photo::Init::CONFIG_FILE) 
      if File.exists?("#{Photo::Init::CONFIG_FILE}.bak")
        File.rename("#{Photo::Init::CONFIG_FILE}.bak", Photo::Init::CONFIG_FILE)
      end
    end

    let(:source) { '/some/source' }
    let(:target) { '/some/target' }
    let(:backup) { '/some/backup' }

    it 'should save user settings' do
      Photo::Init.new({:settings => {source: source, target: target, backup: backup}})
      settings = YAML.load_file(Photo::Init::CONFIG_FILE)
      settings.should == {source: source, target: target, backup: backup}
    end
  end
end
