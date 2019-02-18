#!/usr/bin/env fish

function _fk_clone -a repository
    if echo $repository | grep '/' > /dev/null
        _fk_github_clone $repository $repository
    else
        _fk_github_clone "$fk_github_user/$repository" $repository
    end

    if test $status -eq 0
        _fk_cd $repository
    end
end
