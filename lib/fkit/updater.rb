require_relative '../fkit'

module FKit
  class Updater
    UPDATE_TIMESTAMP_FILE = "#{ENV['HOME']}/.config/fantastic-kit/lastUpdated"

    def need_to_update?
      (Time.now - last_updated) > configs.get(key: 'updatePollIntervalS').to_i
    end

    # TODO actually check for git SHA
    def update!
      kitDir = ENV['FANTASTIC_ROOT']
      raise 'FANTASTIC_ROOT environment variable is not set' unless kitDir
      puts 'Updating fantastic-kit'
      system({'GIT_DIR' => "#{kitDir}/.git"}, 'git pull origin master')
      File.open(UPDATE_TIMESTAMP_FILE, 'w') { |f| f.write(Time.now.to_i) }
    end

    private

    def configs
      @configs ||= Configs.new
    end

    def last_updated
      ensure_timestamp_file_exist
      timestamp = File.open("#{ENV['HOME']}/.config/fantastic-kit/lastUpdated").read
      Time.at(timestamp.to_i)
    end

    def ensure_timestamp_file_exist
      unless File.exist?(UPDATE_TIMESTAMP_FILE)
        File.open(UPDATE_TIMESTAMP_FILE, 'w') { |f| f.write(0) }
      end
    end
  end
end
