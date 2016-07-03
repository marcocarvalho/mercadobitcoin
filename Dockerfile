FROM ruby:2.3.1

RUN mkdir -p /app
WORKDIR /app

COPY . /app/
RUN bundle install

ENTRYPOINT /bin/bash
