#!/usr/bin/env fish

function _fk_script -a script
    $HOME/.config/fish/functions/_fk_$script.rb $argv[2..-1]
end
