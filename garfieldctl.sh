#!/bin/bash

DOCKER_ENV=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
		PORT="-p 8000:80 -p 3000:3000"
	fi

	docker run -d \
		$PORT \
		-v $DIR/logs:/var/log/nginx \
		-v $DIR/sockets:/sockets \
		-v $DIR/www:/var/www \
		-v $DIR/sockets:/sockets \
		-v $DIR/configs:/configs \
		$TAG:latest > $DIR/container.pid

	refresh_container_id

	if [ "$DOCKER_ENV" == "PRODUCTION" ];
	then
		docker exec -i -t $CONTAINER_ID cp /configs/localhost.prod.conf /etc/nginx/sites-enabled/

		# Delete stale sockets.
		rm -f $DIR/sockets/nginx.sock
	else
		docker exec -i -t $CONTAINER_ID cp /configs/localhost.dev.conf /etc/nginx/sites-enabled/

		# If on a mac, and using docker-machine, print its IP so we know what to hit.
		docker-machine >/dev/null 2>&1 && docker-machine ip
	fi

	# Start nginx in the container.
	docker exec -i -t $CONTAINER_ID nginx

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

	sleep 2

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
