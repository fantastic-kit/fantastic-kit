#!/usr/bin/env bash

appendIfNotExist() {
  if ! grep -Fxq "$1" $HOME/.zshrc; then
    echo $1 | tee -a $HOME/.zshrc
  fi
}

kitDir=$HOME/.fantastic-kit
kitConfigDir=$HOME/.config/fantastic-kit
kitRootSrcDir=$HOME/src/github.com

# check if git is installed
if ! command -v git > /dev/null; then
  echo "Git is required to install fantastic-kit. Please install git"
  exit 1
fi

# in case user has already installed fk, nuke everything and reinstall
if [[ -d $kitDir ]]; then
  read -p "fantastic-kit is already installed in the system, do you want to clean reinstall? [Yy/Nn]" reclone < /dev/tty
  if [[ $reclone == [Yy] ]]; then
    echo "Removing existing fantastic-kit files"
    rm -rf $kitDir
    git clone --depth=1 https://github.com/fantastic-kit/fantastic-kit.git $kitDir
  else
    echo "Skipping recloning fantastic-kit"
  fi
else
  echo "Downloading fantastic-kit source to $kitDir"
  git clone --depth=1 https://github.com/fantastic-kit/fantastic-kit.git $kitDir
fi

# setup $HOME/.config/fantastic-kit
mkdir -p $kitConfigDir
echo $(date +'%s') > $kitConfigDir/lastUpdated

kitGitUsername=$(git config user.name)
read -p "Enter your git usename (default: $kitGitUsername): " gitUsername < /dev/tty
if [[ -n $gitUsername ]]; then
  kitGitUsername=$gitUsername
  echo "Setting git username to $kitGitUsername"
fi

read -p "Setting up root source repository path (default: $kitRootSrcDir): " rootSrcDir < /dev/tty
if [[ -n $rootSrcDir ]]; then
  eval expandedPath=$rootSrcDir
  kitRootSrcDir=$expandedPath
  echo "Creating directory: $kitRootSrcDir"
fi

currentVersion=$(git --git-dir="$kitDir/.git" rev-parse HEAD)
mkdir -p $kitRootSrcDir
erb sha="$currentVersion" \
    rootSrcPath="$kitRootSrcDir" \
    gitUsername="$kitGitUsername" \
    "$kitDir/configs/default_config.yml.erb" > "$kitConfigDir/config.yml"
cp "$kitConfigDir/config.yml" "$kitConfigDir/.config.yml.backup" # back a copy of the config file as backup

echo -e "Appending following configurations to ~/.zshrc\e[91m"

appendIfNotExist "######## Setup script setup by fantastic-kit ########"

# export env var for fantastic-kit itself
appendIfNotExist "export FANTASTIC_ROOT=\$HOME/.fantastic-kit"

# update $PATH to include scripts needed for fk
appendIfNotExist "export PATH=\$FANTASTIC_ROOT/bin:\$PATH"

# sourcing fk.sh if it is not already added to the .zshrc file
appendIfNotExist "source \$FANTASTIC_ROOT/bin/fk.sh"

# sourcing fk.sh if it is not already added to the .zshrc file
appendIfNotExist "source \$HOME/.fantastic-kit/bin/fk.sh"

# setup fpath for autocomplete function
appendIfNotExist "fpath=(\$FANTASTIC_ROOT/autocompletion \$fpath)"
appendIfNotExist "autoload -Uz compinit"
appendIfNotExist "compinit"

appendIfNotExist "######### End of the auto generated scripts #########"

echo -e "\e[39mInstallation complete, please run \e[94msource ~/.zshrc \e[39mto enable fantastic-kit"
