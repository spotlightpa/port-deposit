FROM wordpress:latest as plugins

RUN apt-get update && apt-get install -y git

WORKDIR /src
RUN git clone https://github.com/deliciousbrains/wp-amazon-s3-and-cloudfront.git
RUN git clone https://github.com/INN/largo.git && cd largo && git checkout v0.6.4
# Patch
COPY custom-less-variables.php largo/inc/custom-less-variables.php

FROM wordpress:latest

RUN a2enmod proxy proxy_http ssl proxy_ajp rewrite deflate headers proxy_balancer proxy_connect proxy_html && a2dissite 000-default
COPY apache/default.conf /etc/apache2/sites-available/proxy-host.conf
COPY apache/ports.conf /etc/apache2/ports.conf
RUN a2ensite proxy-host

COPY --from=plugins /src/largo /usr/src/wordpress/wp-content/themes/largo
COPY --from=plugins /src/wp-amazon-s3-and-cloudfront /usr/src/wordpress/wp-content/plugins/amazon-s3-and-cloudfront

# Can't change /var/www/html because it is a volume
WORKDIR /var/www/html/news

