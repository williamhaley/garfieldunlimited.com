#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run -d -p 80:80 \
	-v $DIR/logs:/var/log/nginx \
	-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
	-v $DIR/www:/var/www/html \
	test-tag1:latest > docker.running-containerid
