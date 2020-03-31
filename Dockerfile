FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:team-xbmc/ppa \
    && apt-get update \
    && apt-get install -y kodi \
    && apt-get remove --purge -y software-properties-common \
    && apt-get autoremove --purge -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=":0"

ENTRYPOINT [ "/usr/bin/kodi" ]