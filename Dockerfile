FROM ubuntu:22.04

ARG RUNNER_VERSION="2.317.0"
ARG ARCH="x64"

# Prevents installation of some stuff
ARG DEBIAN_FRONTEND=noninteractive

# Upd+Upgr. & create user
RUN apt update && apt upgrade -y && useradd -m docker

# Install some requirements
RUN apt install -y --no-install-recommends \
  curl jq build-essential libssl-dev libffi-dev python3 python3-venv \
  python3-dev python3-pip gcc cmake g++

# Install runner config files
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
  && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENTRYPOINT [ "./start.sh" ]
