ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

ARG NODE_VERSION=latest
ARG DOCKER_COMPOSE_VERSION=1.17.0

LABEL maintainer="colby@dauphina.is"

# install linux packages
RUN apt-get update -yq && \
  apt-get install -yq \
    apt-transport-https \
    curl \
    jq \
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

# install docker && docker-compose
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get update -yq && \
  apt-get install -yq docker-ce && \
  curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose;

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

# install aws cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip -q awscli-bundle.zip && \
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm -R awscli-bundle.zip ./awscli-bundle;

# install ecs-deploy
RUN git clone https://github.com/silinternational/ecs-deploy.git && \
    cp ecs-deploy/ecs-deploy /usr/bin/ecs-deploy && \
    rm -rf ecs-deploy;

CMD ["/bin/bash"] 