require 'yaml'
require 'fileutils'

module FKit
  class Configs
    CONFIG_PATH = "#{ENV['HOME']}/.config/fantastic-kit/config.yml"
    DEFAULT_CONFIG_PATH = "#{ENV['FANTASTIC_ROOT']}/configs/default_config.yml"

    def get(key: nil)
      raise ArgumentError if key.nil?
      raise ArgumentError unless configs.has_key?(key)
      configs[key]
    end

    def set!(key: nil, value: nil)
      raise ArgumentError if key.nil? or key.nil?
      configs[key] = value
      File.open(CONFIG_PATH, 'w') { |f| f.write configs.to_yaml }
    end

    def all
      configs
    end

    private

    def configs
      ensure_configs_file_exist
      @configs ||= YAML.load_file(CONFIG_PATH)
    end

    def ensure_configs_file_exist
      unless File.exist?(CONFIG_PATH)
        FileUtils.cp DEFAULT_CONFIG_PATH, CONFIG_PATH
      end
    end
  end
end
