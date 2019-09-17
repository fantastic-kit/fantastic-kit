require_relative '../fan'

module Fan
  class Updater

    def need_to_update?
      (Time.now - last_updated) > configs.get(key: 'updatePollIntervalS').to_i
    end

    def update!
      kitDir = ENV['FANTASTIC_ROOT']
      raise 'FANTASTIC_ROOT environment variable is not set' unless kitDir
      system({'GIT_DIR' => "#{kitDir}/.git"}, 'git pull origin master')
    end

    private

    def configs
      @configs ||= Configs.new
    end

    def last_updated
      timestamp = File.open("#{ENV['HOME']}/.config/fantastic-kit/lastUpdated").read
      Time.at(timestamp.to_i)
    end
  end
end
