#!/usr/bin/env fish

function fk -d "Command line utility for faster development process" -a cmd
    if test ! -e $HOME/.config/fish/completions/fk.fish
        echo "fk complete" > $HOME/.config/fish/completions/fk.fish
        _fk_complete
    end

    while test -z "$fk_github_user";
        read --prompt-str "Enter your github username: " -U fk_github_user
    end

    switch "$cmd"
        case cd
            _fk_cd $argv[2..-1]
        case clone
            _fk_clone $argv[2..-1]
        case pr
            _fk_pr
        case complete
            _fk_complete
        case {,-h,{,--}help}
            _fk_help
    end
end
