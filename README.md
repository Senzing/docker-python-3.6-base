# docker-python-3.6-base

## :no_entry: Deprecated

Deprecated in favor of Python 3.7 and above.
See [Senzing/docker-senzing-base](https://github.com/Senzing/docker-senzing-base)

[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)

## Overview

The `senzing/python-3.6-base` docker image is a Senzing-ready, python 3.6 image.
The image can be used in a Dockerfile `FROM senzing/python-3.6-base` statement to simplify
building apps with Senzing.

To see how to use the `senzing/python-X.X-base` docker images, see
[github.com/senzing/docker-python-demo](https://github.com/senzing/docker-python-demo).
To see a demonstration of senzing, python, and mysql, see
[github.com/senzing/docker-compose-mysql-demo](https://github.com/senzing/docker-compose-mysql-demo).

### Contents

1. [Demonstrate](#demonstrate)
    1. [Build docker image](#build-docker-image)
    1. [Create SENZING_DIR](#create-senzing_dir)
    1. [Set environment variables for demonstration](#set-environment-variables-for-demonstration)
    1. [Run docker container](#run-docker-container)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Set environment variables for development](#set-environment-variables-for-development)
    1. [Clone repository](#clone-repository)
    1. [Build docker image](#build-docker-image)

## Demonstrate

### Build docker image

```console
sudo docker build --tag senzing/python-3.6-base https://github.com/senzing/docker-python-3.6-base.git
```

### Create SENZING_DIR

If you do not already have an `/opt/senzing` directory on your local system, here's how to install the code.

1. Set environment variable

    ```console
    export SENZING_DIR=/opt/senzing
    ```

1. Download [Senzing_API.tgz](https://s3.amazonaws.com/public-read-access/SenzingComDownloads/Senzing_API.tgz)

    ```console
    curl -X GET \
      --output /tmp/Senzing_API.tgz \
      https://s3.amazonaws.com/public-read-access/SenzingComDownloads/Senzing_API.tgz
    ```

1. Extract [Senzing_API.tgz](https://s3.amazonaws.com/public-read-access/SenzingComDownloads/Senzing_API.tgz)
   to `${SENZING_DIR}`.

    1. Linux

        ```console
        sudo mkdir -p ${SENZING_DIR}

        sudo tar \
          --extract \
          --owner=root \
          --group=root \
          --no-same-owner \
          --no-same-permissions \
          --directory=${SENZING_DIR} \
          --file=/tmp/Senzing_API.tgz
        ```

    1. macOS

        ```console
        sudo mkdir -p ${SENZING_DIR}

        sudo tar \
          --extract \
          --no-same-owner \
          --no-same-permissions \
          --directory=${SENZING_DIR} \
          --file=/tmp/Senzing_API.tgz
        ```

### Set environment variables for demonstration

1. Identify the database username and password.
   Example:

    ```console
    export MYSQL_USERNAME=root
    export MYSQL_PASSWORD=root
    ```

1. Identify the database that is the target of the SQL statements.
   Example:

    ```console
    export MYSQL_DATABASE=G2
    ```

1. Identify the host running mySQL server.
   Example:

    ```console
    sudo docker ps

    # Choose value from NAMES column of docker ps
    export MYSQL_HOST=docker-container-name
    ```

### Run docker container

1. Option #1 - Run the docker container without database or volumes.

    ```console
    sudo docker run -it \
      senzing/python-3.6-base
    ```

1. Option #2 - Run the docker container with database and volumes.

    ```console
    sudo docker run -it  \
      --volume ${SENZING_DIR}:/opt/senzing \
      --env SENZING_DATABASE_URL="mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@${MYSQL_HOST}:3306/${MYSQL_DATABASE}" \
      senzing/python-3.6-base
    ```

1. Option #3 - Run the docker container accessing a database in a docker network.

   Identify the Docker network of the mySQL database.
   Example:

    ```console
    sudo docker network ls

    # Choose value from NAME column of docker network ls
    export MYSQL_NETWORK=nameofthe_network
    ```

    Run docker container.

    ```console
    sudo docker run -it  \
      --volume ${SENZING_DIR}:/opt/senzing \
      --net ${MYSQL_NETWORK} \
      --env SENZING_DATABASE_URL="mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@${MYSQL_HOST}:3306/${MYSQL_DATABASE}" \
      senzing/python-3.6-base
    ```

## Develop

### Prerequisite software

The following software programs need to be installed.

#### git

```console
git --version
```

#### make

```console
make --version
```

#### docker

```console
sudo docker --version
sudo docker run hello-world
```

### Set environment variables for development

1. These variables may be modified, but do not need to be modified.
   The variables are used throughout the installation procedure.

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-python-3.6-base
    export DOCKER_IMAGE_TAG=senzing/python-3.6-base
    ```

1. Synthesize environment variables.

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    export GIT_REPOSITORY_URL="git@github.com:${GIT_ACCOUNT}/${GIT_REPOSITORY}.git"
    ```

### Clone repository

1. Get repository.

    ```console
    mkdir --parents ${GIT_ACCOUNT_DIR}
    cd  ${GIT_ACCOUNT_DIR}
    git clone ${GIT_REPOSITORY_URL}
    ```

### Build docker image

1. Option #1 - Using make command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make docker-build
    ```

1. Option #2 - Using docker command

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag ${DOCKER_IMAGE_TAG} .
    ```
