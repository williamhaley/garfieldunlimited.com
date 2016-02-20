#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NAME="garfieldctl.sh"

# TODO WFH Get a meaningful tag name.
TAG="test-tag1"

do_build()
{
	docker build -t $TAG $DIR

	RETVAL="$?"

	return "$RETVAL"
}

do_start()
{
	do_build

	# TODO WFH Only expose an HTTP port for debugging. Maybe if we pass in a
	# flag like "debug" or "dev".s
	# -p 8008:80

	docker run -d \
		-v $DIR/logs:/var/log/nginx \
		-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
		-v $DIR/www:/var/www/html \
		-v $DIR/nginx/run:/var/run/nginx \
		$TAG:latest > $DIR/container.pid

	RETVAL="$?"

	return "$RETVAL"
}

do_stop()
{
	CONTAINER_ID=$(docker ps | grep -i "$TAG" | cut -d' ' -f1)

	docker stop $CONTAINER_ID

	RETVAL="$?"

	return "$RETVAL"
}

do_restart()
{
	do_stop
	do_start

	RETVAL="$?"

	return "$RETVAL"
}

do_shell()
{
	CONTAINER_ID=$(docker ps | grep -i "$TAG" | cut -d' ' -f1)

	docker exec -i -t $CONTAINER_ID /bin/bash

	RETVAL="$?"

	return "$RETVAL"
}

do_install()
{
	[[ $EUID -ne 0 ]] && echo "Must run as root." && exit 1

	cp /srv/garfieldunlimited.com/nginx/host-garfieldunlimited.com.conf /etc/nginx/sites-available/

	ln -sf /etc/nginx/sites-available/host-garfieldunlimited.com.conf /etc/nginx/sites-enabled/

	service nginx restart

	RETVAL="$?"

	return "$RETVAL"
}

case "$1" in
	start)
		do_start
		;;
	stop)
		do_stop
		;;
	restart)
		do_restart
		;;
	build)
		do_build
		;;
	shell)
		do_shell
		;;
	install)
		do_install
		;;
	*)
		echo "Usage: $NAME {build|start|stop|restart|shell|install}" >&2
		exit 3
		;;
esac

:
