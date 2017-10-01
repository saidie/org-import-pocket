FROM ruby:2.4.2

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN bundle install --system
