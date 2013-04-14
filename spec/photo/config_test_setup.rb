module Photo
  module ConfigTestSetup
    SETTINGS =  {:settings => { source: 'tmp/source',
                                target: 'tmp/target',
                                backup: 'tmp/backup',
                                photo_ext: 'RW2',
                                video_ext: 'MTS',
                                progress_output: File.new(File::NULL, 'w+')  }}
  end
end
