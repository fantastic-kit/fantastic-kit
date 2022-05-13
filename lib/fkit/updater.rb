require 'net/http'
require 'json'

require_relative '../fkit'

module FKit
  class Updater
    UPDATE_TIMESTAMP_FILE = "#{ENV['HOME']}/.config/fantastic-kit/lastUpdated"
    RELEASE_TAG_BASE_URL= 'https://api.github.com/repos/fantastic-kit/fantastic-kit/git/refs/tags'

    def need_to_update?
      old_enough? && latest_version != current_version
    end

    def update!
      kitDir = ENV['FANTASTIC_ROOT']
      raise 'FANTASTIC_ROOT environment variable is not set' unless kitDir
      puts 'Updating fantastic-kit'
      system({'GIT_DIR' => "#{kitDir}/.git"}, 'git pull origin master')
      File.open(UPDATE_TIMESTAMP_FILE, 'w') { |f| f.write(Time.now.to_i) }
      configs.set!(key: 'sha', value: latest_version)
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

    def latest_version
      begin
        @latest_version ||= fetch_latest_sha_from_github
      rescue
        exit
      end
    end

    def fetch_latest_sha_from_github
      uri = URI("#{RELEASE_TAG_BASE_URL}/#{tag_name}")
      resp = Net::HTTP.get(uri)
      if resp.kind_of? Net::HTTPSuccess
        hash = JSON[resp]
        hash['object']['sha']
      else
        raise "Unable to contact GitHub"
      end
    end

    def tag_name
      @tag_name ||= configs.get(key: 'branch')
    end

    def current_version
      @current_version ||= configs.get(key: 'sha')
    end

    def update_poll_interval
      @update_poll_interval ||= configs.get(key: 'updatePollIntervalS').to_i
    end

    def old_enough?
      (Time.now - last_updated) > update_poll_interval
    end
  end
end
