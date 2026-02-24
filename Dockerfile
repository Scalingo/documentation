# Inspiration: https://github.com/timbru31/docker-ruby-node/blob/master/3.2/18/Dockerfile
FROM ruby:3.4.8
LABEL maintainer "kevin@scalingo.com"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT
ARG NODE_MAJOR=18

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN printf 'Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 1001' > /etc/apt/preferences.d/nodesource \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
  nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

COPY Gemfile Gemfile.lock /usr/src/app/

RUN gem install bundler:2.4.22

WORKDIR /usr/src/app
