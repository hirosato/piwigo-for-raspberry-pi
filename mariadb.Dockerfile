FROM alpine:3.8
COPY ./setupdb.sh /
RUN apk --no-cache add mariadb mariadb-client \
  && addgroup mysql mysql \
  && chmod +x /setupdb.sh
VOLUME /var/lib/mysql
EXPOSE 3306
ENTRYPOINT ["/setupdb.sh"]
