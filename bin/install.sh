#!/usr/bin/env bash

appendIfNotExist() {
  if ! grep -Fxq "$1" $HOME/.zshrc; then
    if $2; then
      echo "Appending $1 to .zshrc"
    fi
    echo $1 >> $HOME/.zshrc
  fi
}

kitDir=$HOME/.fantastic-kit

# in case user has already installed fk, nuke everything and reinstall
if [ -d $kitDir ]; then
  echo "found existing fantastic-kit installation. Removing old files..."
  rm -rf $kitDir
fi


echo "Downloading fantastic-kit source to $kitDir"
mkdir -p "$kitDir"
cd $kitDir
git clone --depth=1 https://github.com/fantastic-kit/fantastic-kit.git .

appendIfNotExist "######## Setup script setup by fantastic-kit ########" false

# sourcing fk.sh if it is not already added to the .zshrc file
appendIfNotExist "source \$HOME/.fantastic-kit/bin/fk.sh" true

# export env var for fantastic-kit itself
appendIfNotExist "export FANTASTIC_ROOT=$kitDir" true

# update $PATH to include scripts needed for fk
appendIfNotExist "export PATH=$kitDir/bin:$PATH" true

# setup fpath for autocomplete function
appendIfNotExist "fpath=(\$HOME/.fantastic-kit/autocompletion \$fpath)" true
appendIfNotExist "autoload -Uz compinit"
appendIfNotExist "compinit"

appendIfNotExist "######### End of the auto generated scripts #########" false

echo -e "Installation complete, please run \e[94msource ~/.zshrc \e[39mto enable fantastic-kit"
