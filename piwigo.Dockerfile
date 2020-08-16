FROM alpine:3.8
WORKDIR /
RUN  apk update \
  && apk add --no-cache apache2 php7-apache2 php7 php7-mysqli php7-mbstring php7-session php7-curl php7-json php7-xml php7-zip php7-ctype php7-dom php7-simplexml php7-iconv php7-tokenizer php7-exif php7-gd openssl openrc \
  && rm -rf /var/cache/apk/* \
  && wget -O piwigo.zip http://piwigo.org/download/dlcounter.php?code=latest \
  && unzip piwigo.zip \
  && rm -f piwigo.zip \
  && mkdir /opt \
  && mv piwigo /opt/piwigo \
  && chown -R apache:apache /opt/piwigo \
  && ln -s  /opt/piwigo /var/www/localhost/htdocs \
  && mkdir -p /run/apache2 \
  && sed -i -e 's/max_execution_time = 30/max_execution_time = 200/' /etc/php7/php.ini \
  && sed -i -e 's/post_max_size = 8M/post_max_size = 100M/' /etc/php7/php.ini \
  && sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php7/php.ini \
  && sed -i -e 's/memory_limit = 128M/memory_limit = 256M/' /etc/php7/php.ini
EXPOSE 80
VOLUME /opt/piwigo
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
