#!/usr/bin/env fish

function fk -d "Command line utility for streamlining development process" -a cmd
    while test -z $fk_github_user;
        read --prompt-str "Enter your github username: " -U $fk_github_user
    end

    switch $cmd
        case cd
            _fk_cd $argv[2]
        case clone
            _fk_clone $argv[2]
        case complete
            _fk_complete
    end
end
