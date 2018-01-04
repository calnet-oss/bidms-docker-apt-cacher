## Purpose

This [Docker](http://www.docker.com/) image runs an
[apt-cacher-ng](https://www.unix-ag.uni-kl.de/~bloch/acng/) server that
proxies and caches [Apt](https://wiki.debian.org/Apt) downloads for
Debian-based systems that use the Apt package management system.  This
container exposes port 3142, the apt proxy port.

The author does not currently publish the image in any public Docker
repository but a script, described below, is provided to easily create your
own image.

## License

The source code, which in this project is primarily shell scripts and the
Dockerfile, is licensed under the [BSD two-clause license](LICENSE.txt).

## Building the Docker image

Copy `config.env.template` to `config.env` and edit to set config values.

This image depends on the the base BIDMS Debian Docker image from the
[bidms-docker-debian-base](http://www.github.com/calnet-oss/bidms-docker-debian-base)
project.  If you don't have that image built yet, you'll need that first.

Build the container image:
```
./buildImage.sh
```

## Running

To run the container interactively (which means you get a shell prompt):
```
./runContainer.sh
```

Or to run the container detached, in the background:
```
./detachedRunContainer.sh
```

If everything goes smoothly, the container should expose port 3142, the apt
proxy port.  This port is redirected to a port on the host, where the host
port number is specified in `config.env` as `LOCAL_APT_CACHER_PORT`.

You can then configure Apt to use this proxy.

[There are a few different ways to do this](https://www.unix-ag.uni-kl.de/~bloch/acng/)
but our preferred way is to do it this way:
```
ARG APT_PROXY_URL="http://apt-cacher-proxy:13142" && echo "Acquire::http::Proxy \"$APT_PROXY_URL\";" | sudo tee /etc/apt/apt.conf.d/00aptproxy
```

Replace apt-cacher-proxy with the hostname where this docker container is
running and replace port 13142 with the `LOCAL_APT_CACHER_PORT` specified
in `config.env`.

If running the container interactively, you can exit the container by
exiting the bash shell.  If running in detached mode, you can stop the
container with: `docker stop bidms-apt-cacher` or there is a
`stopContainer.sh` script included to do this.

To inspect the running container from the host:
```
docker inspect bidms-apt-cacher
```

To list the running containers on the host:
```
docker ps
```

## apt-cacher-ng Persistence

Docker will mount the host directory specified in
`HOST_APT_CACHER_DIRECTORY` from `config.env` within the container as `/v1`
and this is where apt-cacher-ng stores its cache.
