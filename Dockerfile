FROM ubuntu

RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y npm curl
RUN npm install -g n
RUN n 4.3.1

# Run nginx in foreground.
# RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Delete the default nginx config.
RUN rm /etc/nginx/sites-enabled/default

CMD cd /var/www && npm install && node /var/www/server.js

EXPOSE 80
EXPOSE 3000
