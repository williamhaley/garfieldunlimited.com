#!/bin/bash

set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
#/home/will/Workspace/GarfieldUnlimited.com/nginx/sites-enabled

docker run -d -p 80:80 \
	-v $DIR/logs:/var/log/nginx \
	-v $DIR/nginx/sites-enabled:/etc/nginx/sites-enabled \
	-v $DIR/www:/var/www/html \
	test-tag1:latest > docker.running-containerid
