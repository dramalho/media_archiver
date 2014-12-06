module MediaArchiver
  class MediaFile
    attr_reader :path, :file_name

    def initialize(file_path)
      @path = file_path
      @file_name = File.basename(@path)

      begin
        @file = MiniExiftool.new(file_path)
        @info = @file.to_hash
      rescue MiniExiftool::Error
        nil
      end
    end

    def valid?
      @file
    end

    def exif_tags
      @info
    end

    def date_created
      exif_tags['DateTimeOriginal'].to_date.to_s if exif_tags['DateTimeOriginal']
    end

    def camera_maker
      exif_tags['Make']
    end

    def camera_model
      exif_tags['Model']
    end
  end
end
