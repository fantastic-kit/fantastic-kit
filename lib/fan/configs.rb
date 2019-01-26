require 'yaml'

module Fan
  class Configs
    CONFIG_PATH = "#{ENV['HOME']}/.config/fantastic-kit/config.yml"

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
      @configs ||= YAML.load_file(CONFIG_PATH)
    end
  end
end
