FROM debian:latest
MAINTAINER Gleb Poljakov <gleb.poljakov@gmail.com>

ENV PHPIPAM_SOURCE https://github.com/phpipam/phpipam/archive/master.tar.gz
ENV HTML_DIR /var/www/html
ENV MYSQL_SERVER mysql

# Install required deb packages
RUN apt-get update &&			\
    apt-get install -y			\
	ca-certificates			\
	curl				\
	apache2				\
	php5				\
	php-pear			\
	php5-curl			\
	php5-mysql			\
	php5-json			\
	php5-gmp			\
	php5-mcrypt			\
	php5-ldap			\
	--no-install-recommends && 	\
    apt-get clean && 			\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure Apache
RUN \
    ln -sf /dev/stdout /var/log/apache2/access.log &&	\
    ln -sf /dev/stderr /var/log/apache2/error.log &&	\
    rm /var/www/html/index.html &&			\
    a2enmod rewrite

#COPY php.ini /etc/php/

# copy phpipam sources to web dir 
RUN mkdir -p ${HTML_DIR} && \
    curl -SL ${PHPIPAM_SOURCE} | \
    tar -zx -C ${HTML_DIR}/ --strip-components=1

# Use system environment variables into config.php
RUN mv ${HTML_DIR}/config.dist.php ${HTML_DIR}/config.php && \
    sed -i \ 
    -e "s/\['host'\] = \"localhost\"/\['host'\] = \"${MYSQL_SERVER}\"/" \ 
    ${HTML_DIR}/config.php && \
    chown -R www-data:www-data ${HTML_DIR}

EXPOSE 80 443

COPY run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]
