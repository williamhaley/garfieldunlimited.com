#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bash $DIR/docker-build.sh

docker run -d -p 8008:80 \
	-v $DIR/logs:/var/log/nginx \
	-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
	-v $DIR/www:/var/www/html \
	-v $DIR/nginx/run:/var/run/nginx \
	test-tag1:latest > $DIR/container.pid
