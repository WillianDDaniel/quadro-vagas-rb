# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.2
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

USER root
RUN apt-get update && apt-get install -y wget chromium chromium-driver
USER vscode