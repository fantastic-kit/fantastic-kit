#!/usr/bin/env bash

appendIfNotExist() {
  if ! grep -Fxq "$1" $HOME/.zshrc; then
    echo $1 | tee -a $HOME/.zshrc
  fi
}

kitDir=$HOME/.fantastic-kit
kitConfigDir=$HOME/.config/fantastic-kit

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
cp $kitDir/configs/default_config.yml $kitConfigDir/config.yml
echo $(date +'%s') > $kitConfigDir/lastUpdated

echo -e "Appending following configurations to ~/.zshrc\e[91m"

appendIfNotExist "######## Setup script setup by fantastic-kit ########"

# export env var for fantastic-kit itself
appendIfNotExist "export FANTASTIC_ROOT=\$HOME/.fantastic-kit"

# sourcing fk.sh if it is not already added to the .zshrc file
appendIfNotExist "source \$FANTASTIC_ROOT/bin/fk.sh"

# sourcing fk.sh if it is not already added to the .zshrc file
appendIfNotExist "source \$HOME/.fantastic-kit/bin/fk.sh"

# update $PATH to include scripts needed for fk
appendIfNotExist "export PATH=\$FANTASTIC_ROOT/bin:\$PATH"

# setup fpath for autocomplete function
appendIfNotExist "fpath=(\$FANTASTIC_ROOT/autocompletion \$fpath)"
appendIfNotExist "autoload -Uz compinit"
appendIfNotExist "compinit"

appendIfNotExist "######### End of the auto generated scripts #########"

echo -e "\e[39mInstallation complete, please run \e[94msource ~/.zshrc \e[39mto enable fantastic-kit"
