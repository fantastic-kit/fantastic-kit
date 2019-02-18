#!/usr/bin/env bash

_fk_wrapper_open()
{
    case $(uname) in
        "Darwin")
            open $@ &> /dev/null
            ;;
        "Linux")
            xdg-open $@ &> /dev/null
            ;;
        *)
            echo "Sorry but we don't support $(uname) yet."
            ;;
    esac
}
