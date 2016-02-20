# Garfield Unlimited

## A website for all things Garfield

*And also a fun way for me to mess around with Docker*

This site is in no way endorsed by, or represents, anything or anyone named Garfield. It is simply a satirical website made by a weirdo.

# Dev vs Prod

The `ENV` file can be used to toggle the environment setup.

* `PRODUCTION` - the docker container will have no port forwarding.
* Anything else - the docker container will be exposed on port `8008`.

If the environment is not production, you can bypass the need to have nginx installed on the host machine. It makes dev work easier, but does not totally mimic production.

It is entirely optional to modify this config, but may make more sense as the scope and complexity increase.

The `ENV` file is in git, but changes to it are ignored using `git update-index --assume-unchanged ENV`.

# Install

You should be able to apply these instructions both to your dev environment and a production server.

This assumes you already have a secure host server running with nginx [and docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/).

```
ssh garfieldunlimited.com
sudo mkdir /srv
sudo chown $USER /srv
git clone https://github.com/williamhaley/garfieldunlimited.com /srv/garfieldunlimited.com
./garfieldctl.sh install
```

# Run

```
cd /srv/garfieldunlimited.com
git pull
./garfieldctl.sh start
```

# Control

```
./garfieldctl.sh
```

# Notes

In reality, a website like this is far better off with a traditional nginx setup. This project is meant as a trivial example. There is much more complexity than is necessary, but it is a learning experience.
