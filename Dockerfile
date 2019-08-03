FROM python:latest as largo-getter

WORKDIR /src
RUN git clone https://github.com/INN/largo.git

FROM wordpress:latest

RUN a2enmod proxy proxy_http ssl proxy_ajp rewrite deflate headers proxy_balancer proxy_connect proxy_html && a2dissite 000-default
COPY apache/default.conf /etc/apache2/sites-available/proxy-host.conf
COPY apache/ports.conf /etc/apache2/ports.conf
RUN a2ensite proxy-host

COPY --from=largo-getter /src/largo /usr/src/wordpress/wp-content/themes/largo

# Can't change /var/www/html because it is a volume
WORKDIR /var/www/html/news

