FROM ubuntu

RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y npm curl
RUN npm install -g n
RUN n 4.3.1
RUN npm install express

# RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

CMD node /var/www/html/server.js

EXPOSE 80
EXPOSE 3000
