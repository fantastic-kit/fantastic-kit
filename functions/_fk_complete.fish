#!/usr/bin/env fish

function _fk_complete -d "Generate auto completion for fantastic kit"
    complete -ec fk
    complete -xc fk -n __fish_use_subcommand -a cd -d "Change directory to repository"
    complete -xc fk -n __fish_use_subcommand -a clone -d "Clone a repository from github"
end
