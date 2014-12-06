require 'thor'
require 'mini_exiftool'
require 'yaml'

module MediaArchiver
  class CLI < Thor
    desc 'copy [DIR] [OUTPUT_DIR]', 'Scans a folder and archives media files'
    option :output_dir, aliases: :o
    option :recursive, aliases: :r, type: :boolean, default: true
    option :output_template, default: ':date_created/:camera_maker/:camera_model'
    option :configuration_file, aliases: :c
    def copy(path = Dir.pwd)
      config = configurations(options)

      path = File.expand_path(path)

      MediaFileUtils.new(path).each(config[:recursive]) do |file|
        dest = output_path(file, config[:output_dir], config[:output_template])
        FileUtils.mkdir_p(File.dirname(dest))

        output = ["File: #{dest}"]
        output << if File.exist?(dest)
                    '[SKIP]'
                  else
                    FileUtils.cp(file.path, dest)
                    '[OK]'
                  end

        puts output.join(' ')
      end
    end

    private

    def configurations(options)
      options = symbolize_keys!(options)
      system_configurations.merge(options)
    end

    def system_configurations
      path = [
        File.expand_path(Dir.pwd),
        Dir.home
      ].map { |path| File.join(path, '.media_archiver_conf.yml') }
              .keep_if { |f| File.file? f }
              .first

      return {} unless path

      load_config_file path
    end

    def load_config_file(path)
      symbolize_keys! YAML.load_file(path)
    end

    def output_path(file, output_path, template)
      output = [output_path]

      output += output_template_parts(template).map do |key|
        file.respond_to?(key) ? file.send(key) : file.exif_tags[key.to_s]
      end
      output << file.file_name

      File.join(*output)
    end

    def output_template_parts(template)
      template.split('/').map do |part|
        if part[0] == ':'
          part[1..-1].to_sym
        else
          part
        end
      end
    end

    def symbolize_keys!(hash)
      hash.each_with_object({}) { |(k,v),acc| acc[k.to_sym] = v }
    end
  end
end
