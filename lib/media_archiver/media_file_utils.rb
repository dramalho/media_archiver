module MediaArchiver
  class MediaFileUtils
    def initialize(path)
      @path = path
    end

    def each(recursive)
      files = if recursive
                Dir.glob(File.join(@path, '**', '*'))
              else
                Dir.glob(File.join(@path, '*'))
              end

      files
        .reject { |path| File.directory? path }
        .each_with_object([]) do |file_path, acc|
          file = MediaFile.new(file_path)

          if file.valid?
            yield(file)
            acc << file
          end
        end
    end
  end
end
