#!/bin/bash

rsync --delete -vr --delete-excluded \
	--include="www" --include="www/*" \
	--exclude="*" \
	 . will@garfieldunlimited.com:/srv/nginx/garfieldunlimited.com/

scp config/garfieldunlimited.com.conf will@garfieldunlimited.com:/tmp/

ssh -t will@willhaley.com "sudo mv /tmp/garfieldunlimited.com.conf /etc/nginx/sites-available/ && sudo service nginx restart"

