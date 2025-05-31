FROM debian:buster

#latest version is 8.4
RUN apt-get update && \
    apt-get install -y apt-utils wget php php-fpm php-phar \
    php-mysql mariadb-client php-zip unzip curl sendmail openssl vim && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e 's/listen =.*/listen = 0.0.0.0:9000/g' /etc/php/7.3/fpm/pool.d/www.conf

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root

#tmp
RUN which php-fpm7.3 && php-fpm7.3 -v

RUN mkdir -p /etc/tools
COPY tools/setup.sh /etc/tools/setup.sh
RUN chmod +x /etc/tools/setup.sh

EXPOSE 9000

ENTRYPOINT ["/bin/sh", "/etc/tools/setup.sh"]