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

# Production deployment

A production setup for this app would be a host with docker and nginx. Nginx on the host proxies requests over a unix socket to the container.

This assumes you already have a secure host server running with nginx [and docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/).


```
./garfieldctl.sh install
```

You could do this on your dev machine and in prod to achieve identical setups. However, it's a bit overkill for a local dev setup, so you may feel free to skip all this until you're ready for prime time.

# Dev vs Prod

The `ENV` file can be used to toggle the environment setup.

* `PRODUCTION` - the docker container will have no port forwarding.
* Anything else - the docker container will be exposed on port `8008`.

If the environment is not production, you can bypass the need to have nginx installed on the host machine. It makes dev work easier, but does not totally mimic production.

It is entirely optional to modify this config, but may make more sense as the scope and complexity increase.

The `ENV` file is in git, but changes to it are ignored using `git update-index --assume-unchanged ENV`.

# Control

```
./garfieldctl.sh
```

# Notes

In reality, a website like this is far better off with a traditional nginx setup. This project is meant as a trivial example. There is much more complexity than is necessary, but it is a learning experience.
