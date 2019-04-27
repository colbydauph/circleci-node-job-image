# circleci-node-job-image
A Docker image ([`Dockerfile`](https://docs.docker.com/engine/reference/builder/)) for running Node / JavaScript jobs on CircleCI. Includes a few useful utilities and common libraries for AWS + Docker workflows.

Pre-built images are available for each [release](https://github.com/colbydauph/circleci-node-job-image/releases) on [Docker Hub](https://hub.docker.com/r/colbydauph/circleci-node-job-image/tags). e.g.
```shell
$ docker run -ti --rm colbydauph/circleci-node-job-image:0.5.0
```
*Note. Pre-built images use `--build-arg` defaults.*

See CircleCI Documentation for more details on:
- [Docker Executors](https://circleci.com/docs/2.0/executor-types/#using-docker)
- [Using Custom-Built Docker Images ](https://circleci.com/docs/2.0/custom-images/)

#### Software
```
os      - ubuntu
util    - curl, git, jq, unzip, vim, zip, funk-cli
docker  - docker, docker-compose
aws     - aws, ecs-deploy
js      - node, npm, npx, n, yarn
```

#### Configuring CircleCI

```yml
# .circleci/config.yml
version: 2
jobs:
  build:
    docker:
      - image: colbydauph/circleci-node-job-image:latest
```

#### Building an Image
```shell
$ docker build \
  -t <user-name>/<image-name>:<version> \
  --build-arg GITHUB_ACCESS_TOKEN \
  --build-arg DOCKER_COMPOSE_VERSION=1.17.0 \
  --build-arg NODE_VERSION=latest \
  --build-arg UBUNTU_VERSION=latest \
  .;
```


