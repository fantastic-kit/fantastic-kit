#!/usr/bin/env fish

function _fk_github_clone -a repository directory
    set directory $HOME/src/github.com/$directory
    set ssh_url "git@github.com:$repository.git"

    if test -d $directory
        echo "$directory exists. The repository may already be cloned."
        return
    else if test -e $directory
        echo "Can not clone because $directory exists as a file"
        return
    end

    echo "Cloning from $ssh_url"

    git clone $ssh_url $directory
    _fk_cd $directory
end
