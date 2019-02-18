#!/usr/bin/env fish

function _fk_clone -a repository
    if echo $repository | grep '/' > /dev/null
        _fk_github_clone $repository $repository
    else
        _fk_github_clone "$fk_github_user/$repository" $repository
    end
end
