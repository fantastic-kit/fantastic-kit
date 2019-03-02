#!/usr/bin/env fish

function _fk_pr
    if ! git rev-parse --show-toplevel > /dev/null 2> /dev/null
        echo "Cannot open PR since current directory is not a git repo"
        return 1
    end

    set curr_branch (git symbolic-ref --short HEAD)

    if test curr_branch = "master"
        echo "Cannot open PR for master branch"
        return 2
    end

    set git_remote (git config --get remote.origin.url)
    set repo_name (echo $git_remote | xargs basename | cut -d'.' -f1)
    set owner_name (echo $git_remote | cut -d'/' -f1 | cut -d':' -f2)

    open https://github.com/$owner_name/$repo_name/pull/$curr_branch
end
