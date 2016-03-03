# Garfield Unlimited

## A website for all things Garfield

*And also a fun way for me to mess around with docker*

This site is in no way endorsed by, or represents, anything or anyone named Garfield. It is simply a satirical website made by a weirdo.

# Install on OSX

OSX (and Windows) suffer from some limitations with docker. Since they are not linux-based, they are not able to run the docker enginer natively. OSX (and Windows) run the docker engine in a VM which then runs containers. Docker commands are sent to that VM. The `Docker Toolbox` is the ideal way to setup that VM and the required environment depedencies to get docker working on non-linux systems.

The docker toolbox setup mounts volumes over vboxsf. This means you cannot write unix sockets or hard links to data volumes. This is a loss of capabilities from what can be done with linux. It *is* possible to use NFS, but I have found it to be much more trouble than it is worth right now. Maybe, in the future, the experience for non-linux systems will be improved. For now, be cautious about compatability between these various environments.

Install the [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

To interact with docker, either open the `Docker Quickstart Terminal` app in Spotlight or add an alias for it in bash and then run that alias.

```
# ~/.bashrc
alias dockersh="bash --login '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'"

source ~/.bashrc

dockersh
```

# Run

```
./garfieldctl.sh build
./garfieldctl.sh start
```

# Install in production

```
sudo mkdir /srv
sudo chown $USER /srv
git clone https://github.com/williamhaley/garfieldunlimited.com /srv/garfieldunlimited.com
cd /srv/garfieldunlimited.com
./garfieldctl.sh install
```

# Update in production

```
git pull
./garfieldctl.sh build
./garfieldctl.sh restart
```

# Production vs Development

A production setup for this app would involve a host server with docker and nginx. Nginx on the host proxies requests over a unix socket to the container.

Assuming you already have a secure host server running with nginx [and docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/), you can run this command to setup the host nginx config and other settings.

```
./garfieldctl.sh install
```

You could do this on your dev machine and in prod to achieve identical setups. However, it's a bit overkill for a local dev setup, so you may feel free to skip all this until you're ready for prime time.

When run for production, no http ports are directly served up from the container. Only the unix socket. On a dev setup, http parts are served to make development easier.

The `ENV` file can be used to toggle the environment setup.

* `PRODUCTION` - the docker container will have no port forwarding.
* Anything else - the docker container will server nginx on port `8008` and node on `3000`.

The `ENV` file is in git, but changes to it are ignored using `git update-index --assume-unchanged ENV`.

# Notes

In reality, a website like this is far better off with a traditional nginx setup. This project is meant as a trivial example. There is much more complexity than is necessary, but it is a learning experience.

