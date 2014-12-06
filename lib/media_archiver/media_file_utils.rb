module MediaArchiver
  class MediaFileUtils
    def initialize(path)
      @path = path
    end

    def each(recursive)
      scan_path(recursive)
        .reject { |path| File.directory? path }
        .each_with_object([]) do |file_path, acc|
          file = MediaFile.new(file_path)

          if file.valid?
            yield(file)
            acc << file
          end
        end
    end

    protected

    def scan_path(recursive)
      if recursive
        Dir.glob(File.join(@path, '**', '*'))
      else
        Dir.glob(File.join(@path, '*'))
      end
    end
  end
end
