# Garfield Unlimited

## A website for all things Garfield

*And also a fun way for me to mess around with Docker*

This site is in no way endorsed by, or represents, anything or anyone named Garfield. It is simply a satirical website made by a weirdo.

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
