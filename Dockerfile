ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

ARG GITHUB_ACCESS_TOKEN
ARG NODE_VERSION=latest
ARG DOCKER_COMPOSE_VERSION=1.17.0

ENV NVM_DIR /usr/local/nvm

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

# add token for github private repos
# https://github.com/npm/npm/issues/5257
RUN git config --global url."https://${GITHUB_ACCESS_TOKEN}:x-oauth-basic@github.com/".insteadOf "ssh://git@github.com/"

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

# install node 16 + npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
    apt-get install -yq nodejs build-essential && \
    yarn global add npm

# install n (node version manager)
RUN npm i -g n && \
    n ${NODE_VERSION} -q && \
    yarn global add npm
    
# install nvm
# https://github.com/creationix/nvm#install-script
RUN mkdir -p $NVM_DIR
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.1/install.sh | bash
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules

# install funk-cli
RUN npm i -g colbydauph/funk-cli#0.5.0

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
#     unzip -q awscli-bundle.zip && \
#     sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
#     rm -R awscli-bundle.zip ./awscli-bundle;

# install ecs-deploy
RUN git clone https://github.com/silinternational/ecs-deploy.git && \
    cp ecs-deploy/ecs-deploy /usr/bin/ecs-deploy && \
    rm -rf ecs-deploy;

CMD ["/bin/bash"] 