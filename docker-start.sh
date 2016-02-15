#!/bin/bash

docker run -d -p 80:80 \
	-v www:/var/www/html \
	-v logs:/var/log/nginx \
	test-tag1:latest > docker.running-containerid
