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

	return "$?"
}

do_start()
{
	if [ -n "$CONTAINER_ID" ];
	then
		echo "Container is running."

		return 0
	fi

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

	if [ -n "$CONTAINER_ID" ];
	then
		echo "Container is running."
	else
		echo "Container is not running."

		return 1
	fi

	if [ "$DOCKER_ENV" == "PRODUCTION" ];
	then
		docker exec -i -t $CONTAINER_ID cp /configs/localhost.prod.conf /etc/nginx/sites-enabled/

		# Delete stale sockets.
		rm -f $DIR/sockets/nginx.sock
	else
		docker exec -i -t $CONTAINER_ID cp /configs/localhost.dev.conf /etc/nginx/sites-enabled/

		# If on a mac, and using docker-machine, print its IP so we know what to hit.
		docker-machine >/dev/null 2>&1 && echo "Docker-machine IP is $(docker-machine ip)."
	fi

	# Start nginx in the container.
	docker exec -i -t $CONTAINER_ID nginx

	return "$?"
}

do_stop()
{
	refresh_container_id

	if [ -z "$CONTAINER_ID" ];
	then
		echo "Container stopped."

		rm -f $DIR/container.pid

		refresh_container_id

		return 0
	fi

	echo "Attempting to stop container..."

	docker stop $CONTAINER_ID

	sleep 1

	do_stop
}

do_restart()
{
	do_stop

	sleep 1

	do_start

	return "$?"
}

do_shell()
{
	docker exec -i -t $CONTAINER_ID /bin/bash

	return "$?"
}

# Install configs to host nginx.
do_install()
{
	if [ $EUID -ne 0 ];
	then
		echo "Must run as root."

		return 1
	fi

	cp /srv/garfieldunlimited.com/nginx/host-garfieldunlimited.com.conf /etc/nginx/sites-available/

	ln -sf /etc/nginx/sites-available/host-garfieldunlimited.com.conf /etc/nginx/sites-enabled/

	service nginx restart

	return "$?"
}

case "$1" in
	start)
		do_start

		exit "$?"
		;;
	stop)
		do_stop

		exit "$?"
		;;
	restart)
		do_restart

		exit "$?"
		;;
	build)
		do_build

		exit "$?"
		;;
	shell)
		do_shell

		exit "$?"
		;;
	install)
		do_install

		exit "$?"
		;;
	*)
		echo "Usage: $NAME {build|start|stop|restart|shell|install}" >&2
		exit 3
		;;
esac

:
