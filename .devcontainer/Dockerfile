# Shared image, envs, packages for both devcontainer & prod.
FROM ruby:3.4-bookworm

# Install SAM CLI in a virtual environment to keep Debian's Python managed by apt.
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-venv python-is-python3 \
    && python3 -m venv /opt/aws-sam-cli \
    && /opt/aws-sam-cli/bin/pip install --no-cache-dir aws-sam-cli \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/opt/aws-sam-cli/bin:${PATH}"

# Local devcontainer Codespaces compatibility.
RUN mkdir -p /workspaces/willnet_in
ENV BUNDLE_IGNORE_CONFIG=1
ENV BUNDLE_PATH=./vendor/bundle
ENV BUNDLE_CACHE_PATH=./vendor/cache
