# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /willnet_in

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

RUN useradd willnet --home /willnet_in --shell /bin/bash
USER willnet:willnet

EXPOSE 80
CMD ["bundle", "exec", "puma", "--port", "80", "-e", "production"]
