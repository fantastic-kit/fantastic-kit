#!/usr/bin/env bash

# $1 0 if feature request, else bug.
_fk_create_issue()
{
    if [[ $1 -eq 0 ]]; then
        issue_type="request a feature"
    else
        issue_type="report a bug"
    fi

    echo "If you wish to $issue_type, please create an issue at"
    echo "https://github.com/fantastic-kit/fantastic-kit/issues/new"
}

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
            _fk_create_issue 0
            ;;
    esac
}
