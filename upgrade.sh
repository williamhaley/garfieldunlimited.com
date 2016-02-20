#!/bin/bash

git pull

sudo cp /srv/garfieldunlimited.com/nginx/host-garfieldunlimited.com.conf /etc/nginx/sites-enabled/

sudo service nginx restart

./docker-stop.sh

./docker-start.sh
