#!/usr/bin/env fish

function _fk_cd -d "Change directory to the provided repository directory" -a repository
    cd $HOME/src/github.com/$repository
end
