# Garfield Unlimited

## A website for all things Garfield

*And also a fun way for me to mess around with Docker*

This site is in no way endorsed by, or represents, anything or anyone named Garfield. It is simply a satirical website made by a weirdo.

# Install

```
sudo mkdir /srv
sudo chown $USER /srv
git clone https://github.com/williamhaley/garfieldunlimited.com /srv/garfieldunlimited.com
```

# Run

```
cd /srv/garfieldunlimited.com
git pull
./garfieldctl.sh build
./garfieldctl.sh start
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

# Control

```
./garfieldctl.sh
```

# Notes

In reality, a website like this is far better off with a traditional nginx setup. This project is meant as a trivial example. There is much more complexity than is necessary, but it is a learning experience.
