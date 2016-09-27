require 'thor'
require 'mini_exiftool'
require 'yaml'

module MediaArchiver
  class CLI < Thor
    package_name "MediaArchiver"
    map "-R" => :recursive
    map "-O" => :output_dir
    map "-C" => :configuration_file

    DEFAULT_OUTPUT_TEMPLATE = ':DateTimeOriginal/:Make/:Model'

    desc 'copy [DIR]', 'Scans a folder and archives media files'
    method_option :output_dir, aliases: :o, desc: 'Output folder where the files should be copied into'
    method_option :recursive, aliases: :r, type: :boolean, default: true, desc: "Recursivelly scan input folder"
    method_option :output_template
    method_option :configuration_file, aliases: :c
    method_option :overwrite_extensions, type: :array
    def copy(path = Dir.pwd)
      config = configurations(options)

      path = File.expand_path(path)

      MediaFileUtils.new(path).each(config[:recursive]) do |file|
        dest = output_path(file, config[:output_dir], config[:output_template])
        FileUtils.mkdir_p(File.dirname(dest))

        output = ["File: #{dest}"]
        output << if File.exist?(dest)
                    if config[:overwrite_extensions].empty? || !config[:overwrite_extensions].include?(dest.split('.').last.downcase)
                      '[SKIP]'
                    else
                      FileUtils.cp(file.path, dest)
                      '[OVERWRITE]'
                    end
                  else
                    FileUtils.cp(file.path, dest)
                    '[OK]'
                  end

        puts output.join(' ')
      end
    end

    private

    def configurations(options)
      conf = system_configurations.merge symbolize_keys!(options)

      # Defaults that we don't want to set via Thor
      conf[:output_template] = DEFAULT_OUTPUT_TEMPLATE unless conf[:output_template]

      # Sanity checks
      conf[:output_dir] = File.expand_path(conf[:output_dir]) if conf[:output_dir]

      conf
    end

    def system_configurations
      config_file = [
        File.expand_path(Dir.pwd),
        Dir.home
      ].map { |path| File.join(path, '.media_archiver_conf.yml') }
              .keep_if { |f| File.file? f }
              .first

      return {} unless config_file

      load_config_file config_file
    end

    def load_config_file(path)
      symbolize_keys! YAML.load_file(path)
    end

    def output_path(file, output_path, template)
      output = [output_path]

      output += output_template_parts(template).map do |key|
        if key.is_a? Symbol
          value = file.exif_tags[key.to_s.downcase]
          value = value.to_date.to_s if value.is_a?(Time)

          value || "Unknown"
        else
          key
        end
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
      hash.each_with_object({}) { |(k, v), acc| acc[k.to_sym] = v }
    end
  end
end
