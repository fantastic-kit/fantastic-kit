#!/usr/bin/env bash

source $FANTASTIC_ROOT/bin/wrappers.sh

# check for updates
kit-check-update

fcd()
{
  cd $HOME/src/github.com/$1
}

fclone()
{
  cdDir=$1
  if echo $1 | grep '/' > /dev/null; then
    echo "Cloning from git@github.com:$1.git"
    cdDir=$(cut -d'/' -f2 <<< $1)
    if [ ! -d $HOME/src/github.com/$cdDir ]; then
      git clone git@github.com:$1.git $HOME/src/github.com/$cdDir
    else
      echo "Already cloned, done."
    fi
  else
    echo "Cloning from git@github.com:$(git config user.name)/$1.git"
    if [[ ! -d $HOME/src/github.com/$cdDir ]]; then
      git clone git@github.com:$(git config user.name)/$1.git $HOME/src/github.com/$1
    else
      echo "Already cloned, done."
    fi
  fi
  fcd $cdDir
}

fpr()
{
  if git rev-parse --git-dir &> /dev/null; then
    curBranch=$(git symbolic-ref --short HEAD)
    if [[ $curBranch != "master" ]]; then
      # assuming ssh remote since `fclone` clone from ssh remote by default
      repoName=$(git config --get remote.origin.url | xargs basename | cut -d'.' -f1)
      # Only SSH remotes would have @.
      if git config --get remote.origin.url | grep "@" > /dev/null; then
        ownerName=$(git config --get remote.origin.url | cut -d'/' -f1 | cut -d':' -f2)
      else 
        ownerName=$(git config --get remote.origin.url | awk -F "/" '{print $(NF-1)}')
      fi
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
  fk.rb $repoDir/kit.yml $@
}

fload-dev() {
  source $HOME/src/github.com/fantastic-kit/bin/load-dev && load-dev
}


fk()
{
  cmd=$1
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
  *)
    frun $cmd
  ;;
  esac
}
