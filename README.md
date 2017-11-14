# circleci-node-job-image
Docker Image: [`colbydauph/circleci-node-job-image`](https://hub.docker.com/r/colbydauph/circleci-node-job-image)

#### Software
```
os      - ubuntu
util    - curl, git, unzip, vim, zip
cloud   - aws, docker
js      - node, npm, n, yarn
```

#### Building an Image
[CircleCI - Using Custom-Built Docker Images ](https://circleci.com/docs/2.0/custom-images/)
```shell
$ docker build \
  -t <user-name>/<image-name>:<version> \
  --build-arg NODE_VERSION=latest \
  --build-arg UBUNTU_VERSION=latest \
  .;
```

#### Configuring CircleCI
[CircleCI - Docker Executors](https://circleci.com/docs/2.0/executor-types/#using-docker)
```yml
# .circleci/config.yml
version: 2
jobs:
  build:
    docker:
      - image: <user-name>/<image-name>:<version>
```