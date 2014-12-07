module MediaArchiver
  class MediaFile
    attr_reader :path, :file_name, :exif_tags

    def initialize(file_path)
      @path = file_path
      @file_name = File.basename(@path)

      begin
        @file = MiniExiftool.new(file_path)
        @exif_tags = @file.to_hash.each_with_object({}) do |(k, v), acc|
          acc[k.downcase] = v if k
        end
      rescue MiniExiftool::Error
        nil
      end
    end

    def valid?
      @file && @exif_tags
    end
  end
end
