FROM ubuntu:18.04

# install oh-my-zsh
RUN apt-get update && \
  apt-get install -y git curl vim locales gnupg2 zsh ruby && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  chsh -s $(which zsh)

RUN curl -fsSL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# fix docker zsh locale setup
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# overwrite oh-my-zsh configs
COPY misc/zshrc /root/.zshrc

# install necessary plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

WORKDIR /root
CMD ["zsh"]
