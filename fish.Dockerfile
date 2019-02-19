FROM ubuntu:18.04

RUN apt-get update && \
        apt-get install -y git ruby curl fish && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

COPY . /fantastic-kit

SHELL ["fish", "-c"]

RUN fisher add /fantastic-kit

WORKDIR /root
