FROM zshusers/zsh-5.6.2

# install oh-my-zsh
RUN apt-get update && \
  apt-get install -y git ruby curl vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# overwrite oh-my-zsh configs
COPY misc/zshrc /root/.zshrc

# install necessary plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

WORKDIR /root
