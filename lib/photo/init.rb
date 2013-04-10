module Photo
  class Init

    CONFIG_FILE = File.join(ENV['HOME'], '.photo.yaml')

    def initialize(options={})
      settings = options[:settings] || question_user
      save_configuration settings
    end

    private

    def question_user
      options = {}

      puts "Path to photo source: " 
      options[:source] = gets.chomp

      puts "Path to storage on file system: "
      options[:target] = gets.chomp

      puts "Path to backup location: "
      options[:backup] = gets.chomp
      
      puts "Photo file extension: "
      options[:photo_ext] = gets.chomp

      puts "Video file extension: "
      options[:video_ext] = gets.chomp
      
      options
    end

    def save_configuration(settings)
      settings = YAML.dump(settings)
      File.open(CONFIG_FILE, 'w+') { |f|
          f.write(settings) }
    end
  end
end
