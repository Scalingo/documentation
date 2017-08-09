FROM ruby:2.3.1

ENV BUNDLE_BIN /usr/src/app/vendor/.bundle/ruby/2.3.1/bin
ENV BUNDLE_PATH /usr/src/app/vendor/.bundle/ruby/2.3.1
ENV BUNDLE_APP_CONFIG /usr/src/app/.bundle

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN gem install bundler

CMD bundle exec jekyll serve --watch --incremental --host 0.0.0.0 --port 4300
