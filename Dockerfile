FROM ubuntu

# ADD www /var/www/html

RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y npm curl
RUN npm install -g n
RUN n 4.3.1

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/var/log/nginx"]

# Define working directory.
# WORKDIR /etc/nginx

# ADD nginx/sites-enabled /etc/nginx/sites-enabled

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80

