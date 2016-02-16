# Garfield Unlimited

## A website for all things Garfield

*And also a fun way for me to mess around with Docker*

This site is in no way endorsed by, or represents, anything or anyone named Garfield. It is simply a satirical website made by a weirdo.

# Install

Install `docker`.

```
# Build the base image.
docker-build.sh
```

# Run

```
# Run the image.
docker-start.sh
```

This will start the server on port `8008`. That's helpful for dev and debugging, but more importantly, the server will listen on a unix socket that's exposed to the host machine.

You can use the host upstream config to direct traffic to the container on that socket. That way you do not need to worry about port collisions on 80.

**TODO: Uh, test this with an upstream config to make sure that claim is actually true.**

# Server deploy

**TODO**

1. Git pull on server.
1. Copy host nginx conf.
1. Restart docker container. `docker restart ...`
1. Don't really need the previous 2 ^^ if we're simply updating static html files.

**TODO**

Hey, isn't it kind of a downer that this is 1,000,000,000 times more complex than just rsyncing files to an nginx setup? An nginx setup that would normally start up on reboot by default, as opposed to these docker images?

Yeah...but I guess this is a test to get some exposure, and help me form some opinions about when Docker makes sense. Generally speaking, NOT for a static HTML site. Probably more for something that's a PITA to get setup in any environment.
