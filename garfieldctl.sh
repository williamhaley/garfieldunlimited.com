#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/ENV
NAME="garfieldctl.sh"
# TODO WFH Get a meaningful tag name.
TAG="garfieldunlimited"

refresh_container_id()
{
	CONTAINER_ID=$(docker ps | grep -i "$TAG" | cut -d' ' -f1)
}

refresh_container_id

do_build()
{
	docker build -t $TAG $DIR

	RETVAL="$?"

	return "$RETVAL"
}

do_start()
{
	[[ -n "$CONTAINER_ID" ]] && echo "Container [ $TAG ] is already running." && exit 1

	if [ "$DOCKER_ENV" == "PRODUCTION" ];
	then
		PORT=""
	else
		PORT="-p 8008:80 -p 3000:3000"
	fi

	docker run -d \
		$PORT \
		-v $DIR/logs:/var/log/nginx \
		-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
		-v $DIR/www:/var/www \
		-v $DIR/nginx/run:/var/run/nginx \
		$TAG:latest > $DIR/container.pid

	# TODO WFH Comment until I figure out how prod looks vs dev.
	#if [ "$DOCKER_ENV" != "PRODUCTION" ];
	#then
		rm -f $DIR/nginx/run/nginx.sock

		refresh_container_id

		docker exec -i -t $CONTAINER_ID nginx
	#fi

	RETVAL="$?"

	return "$RETVAL"
}

do_stop()
{
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
	docker exec -i -t $CONTAINER_ID /bin/bash

	RETVAL="$?"

	return "$RETVAL"
}

# Install configs to host nginx.
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
