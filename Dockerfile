FROM ubuntu:latest

LABEL maintainer="colby@dauphina.is"

ARG NODE_VERSION=latest

# install linux packages
RUN apt-get update -yq && \
  apt-get install -yq \
    apt-transport-https \
    awscli \
    curl \
    software-properties-common \
    sudo \
    unzip \
    vim \
    zip \
    \
    # Required by CircleCI
    ca-certificates \
    git \
    gzip \
    ssh \
    tar \
  && rm -rf /var/lib/apt/lists/*;

# install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get update -yq && \
  apt-get install -yq docker-ce;

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -yq && \
    apt-get install -yq yarn

# install node 8 + npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get install -yq nodejs build-essential && \
    yarn global add npm

# install n (node version manager)
RUN npm install -g n && \
    n ${NODE_VERSION} -q

RUN git init

# install aws cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip -q awscli-bundle.zip && \
    ./awscli-bundle/install -b ~/bin/aws && \
    rm -R awscli-bundle.zip ./awscli-bundle;

CMD ["/bin/bash"] 