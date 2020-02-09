#!/usr/bin/env bash

source $FANTASTIC_ROOT/bin/wrappers.sh

# check for updates
kit-check-update

fcd()
{
  cd $(fk config --key=rootSrcPath)/$1
}

fclone()
{
  cdDir=$1
  rootSrcPath=$(fk config --key=rootSrcPath)
  if echo $1 | grep '/' > /dev/null; then
    cdDir=$(cut -d'/' -f2 <<< $1)
    echo "Cloning from git@github.com:$1.git to $rootSrcPath/$cdDir"
    if [ ! -d $rootSrcPath/$cdDir ]; then
      git clone git@github.com:$1.git $rootSrcPath/$cdDir
    else
      echo "Already cloned, done."
    fi
  else
    echo "Cloning from git@github.com:$(fk config --key=gitUsername)/$1.git to $rootSrcPath/$cdDir"
    if [[ ! -d $rootSrcPath/$cdDir ]]; then
      git clone git@github.com:$(fk config --key=gitUsername)/$1.git $rootSrcPath/$1
    else
      echo "Already cloned, done."
    fi
  fi
  fcd $cdDir
}

remote-info()
{
  local ownerName=''
  local repoName=''
  repoName=$(basename $(git config --get remote.origin.url) .git)

  if git config --get remote.origin.url | grep "@" > /dev/null; then
    ownerName=$(git config --get remote.origin.url | cut -d'/' -f1 | cut -d':' -f2)
  else 
    ownerName=$(git config --get remote.origin.url | awk -F "/" '{print $(NF-1)}')
fi
  echo $repoName $ownerName
}

fpr()
{
  if git rev-parse --git-dir &> /dev/null; then
    curBranch=$(git symbolic-ref --short HEAD)
    if [[ $curBranch != "master" ]]; then
      read repoName ownerName < <(remote-info)
      branch-exists.rb $repoName $ownerName $curBranch
      if [[ $? -eq 0 ]]; then
        _fk_wrapper_open https://github.com/$ownerName/$repoName/pull/$curBranch
      elif [[ $? -eq -1 ]]; then
        return 1
      fi
    else
      echo "cannot open PR for master branch"
    fi
  else
    echo "cannot open pr since current directory is not a git repo"
    return 1
  fi
}

frepo()
{
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "not in a git repo"
    return 1
  fi
  read repoName ownerName < <(remote-info)
  _fk_wrapper_open https://github.com/$ownerName/$repoName &> /dev/null
}

frun()
{
  originalDir=$(pwd)
  repoDir=$(pwd)
  while :; do
    if [[ $(pwd) == "/" ]]; then
      echo "not in a fantastically enabled dir"
      cd $originalDir
      return 1
    fi
    if [[ -f $(pwd)/kit.yml ]]; then
      repoDir=$(pwd)
      break
    else
      cd ..
    fi
  done
  echo "found kit.yml in $repoDir"
  cd $originalDir
  kit-run $repoDir/kit.yml $@
}

fload-dev() {
  source $HOME/src/github.com/fantastic-kit/bin/load-dev && load-dev
}


fk()
{
  cmd=$1
  if [[ $cmd == '' ]]; then
    kit-help
    return 1
  fi

  shift;
  case $cmd in
  cd)
    fcd $@
  ;;
  clone)
    fclone $@
  ;;
  pr)
    fpr $@
  ;;
  load-dev)
    fload-dev
  ;;
  config)
    kit-config $@
  ;;
  update)
    # enable upgrade flag
    fk config --key=autoUpdateEnabled --value=true > /dev/null
    kit-check-update
  ;;
  repo)
    frepo
  ;;
  help)
    kit-help
  ;;
  *)
    frun $cmd $@
  ;;
  esac
}
