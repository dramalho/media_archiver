require 'thor'
require 'mini_exiftool'
require 'byebug'
require 'yaml'

module MediaArchiver
  class CLI < Thor

    option :output_dir, aliases: :o, default: Dir.pwd
    option :recursive, aliases: :r, type: :boolean, default: true
    option :output_template, default: ':date_created/:camera_maker/:camera_model'
    option :configuration_file, aliases: :c
    desc 'scan [PATH]', 'Scans a folder for media files and returns info'
    def scan(path = Dir.pwd)
      config = configurations(options)

      path = File.expand_path(path)

      MediaFileUtils.new(path).each(options[:recursive]) do |file|
        puts output_path(file, options[:output_dir], options[:output_template])
      end
    end

    desc 'copy [DIR] [OUTPUT_DIR]', 'Scans a folder and archives media files'
    def copy
    end

    private

    def configurations(options)
      system_configurations.merge(options)
    end

    def system_configurations
      path = [
               File.expand_path(Dir.pwd),
               Dir.home
              ].map { |path| File.join(path, '.media_archiver_conf.yml' ) }
              .keep_if { |f| File.file? f }
              .first

      return {} unless path

      load_config_file path
    end

    def load_config_file(path)
      YAML.load_file path
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
  end
end
