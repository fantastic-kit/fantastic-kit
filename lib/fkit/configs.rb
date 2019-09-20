require 'yaml'
require 'fileutils'

module FKit
  class Configs
    CONFIG_PATH = "#{ENV['HOME']}/.config/fantastic-kit/config.yml".freeze
    CONFIG_BACKUP = "#{ENV['HOME']}/.config/fantastic-kit/.config.yml.backup".freeze

    # key constants
    AUTO_UPDATE_ENABLED = 'autoUpdateEnabled'.freeze
    UPDATE_POLL_INTERVAL_S = 'updatePollIntervalS'.freeze

    def get(key: nil)
      raise ArgumentError if key.nil?
      raise ArgumentError unless configs.has_key?(key)
      configs[key]
    end

    def set!(key: nil, value: nil)
      raise ArgumentError if key.nil? or key.nil?
      configs[key] = sanitize_value(value)
      File.open(CONFIG_PATH, 'w') { |f| f.write configs.to_yaml }
    end

    def all
      configs
    end

    def help_text
      msg = <<-EOF
Usage: fk config [options]
  fk config --key=<key>                  -- retrieve value stored at <key>
  fk config --key=<key> --value=<value>  -- set <key> to <value>
      EOF
      msg
    end

    private

    def configs
      ensure_configs_file_exist
      @configs ||= YAML.load_file(CONFIG_PATH)
    end

    def ensure_configs_file_exist
      unless File.exist?(CONFIG_PATH)
        puts 'Corrupt config file detected, attempting repair...'
        if File.file?(CONFIG_BACKUP)
          FileUtils.cp CONFIG_BACKUP, CONFIG_PATH
          puts 'Repair done.'
        else
          raise 'Unable to restore config file, please try reinstall fantastic-kit'
        end
      end
    end

    def sanitize_value(val)
      case val.downcase
      when "true", "yes"
        true
      when "false", "no"
        false
      else
        val
      end
    end
  end
end
