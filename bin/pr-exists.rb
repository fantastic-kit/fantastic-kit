#!/usr/bin/env ruby

# takes 3 argument:
# ARGV[0] = repo owner
# ARGV[1] = repo name
# ARGV[2] = current branch name
#
# returns 0 if repo exists else returns 1, returns 2 if an errror occurred

require 'net/http'
require 'json'

repo_owner  = ARGV[0]
repo_name   = ARGV[1]
branch_name = ARGV[2]

begin
  uri = URI("https://api.github.com/repos/#{repo_owner}/#{repo_name}/pulls?head=#{repo_owner}:#{branch_name}")
  res = Net::HTTP.get(uri)
  data = JSON.parse(res)
rescue => e
  puts "Unable to query github: #{e}"
  exit(2)
end

exit(1) unless data.kind_of?(Array) and data.any? and data.first.has_key?('url')
