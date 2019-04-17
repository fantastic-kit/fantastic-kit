#!/usr/bin/env ruby

# takes 3 argument:
# ARGV[0] = repo owner
# ARGV[1] = repo name
# ARGV[2] = current branch name
#
# Return values:
# Branch exists in remote repo
#   0 - If branch exists in remote repo
#   1 - If branch doesn't exist in remote repo
#
# Otherwise return -1

repo_owner  = ARGV[0]
repo_name   = ARGV[1]
branch_name = ARGV[2]

result = %x(  git branch -a | egrep "remotes/origin/#{branch_name}" | wc -l )
result.strip!

if result.to_i == 1
  # A remote branch exists
  exit(0)
else
  puts <<-EOF
\nfatal: The current branch newbranch has no upstream branch.
To push the current branch and set the remote as upstream, use
\n\tgit push --set-upstream origin #{branch_name}\n\n
EOF
  exit(1)
end
