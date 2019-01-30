#!/usr/bin/env ruby

require 'yaml'

configs = YAML.load_file(ARGV[0])

unless configs && configs.has_key?("commands")
  puts "command section is missing from bev.yml"
  exit(1)
end

cmds = configs["commands"]

unless cmds.has_key?("run") && cmds["run"].has_key?("run")
  puts "`run` command not specified"
  exit(1)
end

cmd = cmds["run"]["run"]

puts "fk is running #{cmd} #{ARGV[2..-1]}"
exec(cmd, ARGV[2..-1].join(' '))
