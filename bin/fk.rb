#!/usr/bin/env ruby

require 'yaml'

configs = YAML.load_file(ARGV[0])
action=ARGV[1]

unless configs && configs.has_key?("commands")
  puts "command section is missing from kit.yml"
  exit(1)
end

cmds = configs["commands"]

unless cmds.has_key?(action) && cmds[action].has_key?("run")
  puts "`run` command not specified"
  exit(1)
end

cmd = cmds[action]["run"]

puts "fk is running #{cmd} #{ARGV[2..-1].join(' ')}"
exec([cmd, ARGV[2..-1].join(' ')].join(' '))
