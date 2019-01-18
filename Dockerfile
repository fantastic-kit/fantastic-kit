from zshusers/zsh-5.6.2

# install oh-my-zsh
run apt-get update && \
  apt-get install -y wget git ruby
run wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# overwrite oh-my-zsh configs
copy misc/zshrc /root/.zshrc

# install necessary plugins
run git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
