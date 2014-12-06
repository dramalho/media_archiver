require 'thor'

module MediaArchiver
  class CLI < Thor
    desc "scan [PATH]","Scans a folder for media files"
    def scan(path = nil)
      puts "Scaning #{path}"
    end
  end
end
