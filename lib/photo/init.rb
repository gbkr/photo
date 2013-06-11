module Photo
  class Init

    CONFIG_FILE = File.join(ENV['HOME'], '.photo.yml')

    def initialize(options={})
      settings = options[:settings] || question_user
      save_configuration settings
    end

    private

    def question_user
      options = {}

      puts "\nPath to photo source: " 
      options[:source] = user_input

      puts "\nPath to storage on file system: "
      options[:target] = user_input

      puts "\nPath to backup location: "
      options[:backup] = user_input
      
      puts "\nPhoto file extension: "
      options[:photo_ext] = user_input

      puts "\nVideo file extension: "
      options[:video_ext] = user_input
     
      puts "\nConfig saved to #{CONFIG_FILE}\n\n"
      options
    end

    def user_input
      STDIN.gets.chomp
    end

    def save_configuration(settings)
      settings = YAML.dump(settings)
      File.open(CONFIG_FILE, 'w+') { |f|
          f.write(settings) }
    end
  end
end
