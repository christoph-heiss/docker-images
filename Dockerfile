FROM alpine:3.15

LABEL org.opencontainers.image.title="tt-rss"
LABEL org.opencontainers.image.description="Tiny Tiny RSS is a free and open source web-based news feed (RSS/Atom) reader and aggregator"
LABEL org.opencontainers.image.source="https://git.tt-rss.org/fox/tt-rss.git/"
LABEL org.opencontainers.image.authors="Christoph Heiss <contact@christoph-heiss.at"
LABEL org.opencontainers.image.url="https://github.com/christoph-heiss/tt-rss-docker"

ARG TTRSS_GIT_COMMIT

WORKDIR /app

ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-x86_64.tar.xz /tmp

RUN \
  BUILD_ONLY_DEPS="xz" \
  && apk --no-cache upgrade \
  && apk --no-cache add \
    php7 php7-fpm php7-pdo php7-gd php7-pgsql php7-pdo_pgsql php7-pcntl php7-posix php7-mbstring \
    php7-intl php7-xml php7-curl php7-ldap php7-dom php7-fileinfo php7-json php7-iconv \
    php7-zip php7-session ca-certificates nginx postgresql14-client git $BUILD_ONLY_DEPS \
  && git clone https://git.tt-rss.org/fox/tt-rss.git . \
  && if [ ! -z $TTRSS_GIT_COMMIT ]; then git checkout $TTRSS_GIT_COMMIT; fi \
  && git clone --depth=1 https://git.tt-rss.org/fox/ttrss-nginx-xaccel.git plugins.local/nginx_xaccel \
  && git clone --depth=1 https://github.com/HenryQW/mercury_fulltext.git plugins.local/mercury_fulltext \
  && addgroup -S -g 1000 www-data2 \
  && adduser -S -u 1000 -H -G www-data2 www-data \
  && chown -R www-data:www-data2 . \
  && cp -a config.php-dist config.php \
  && sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php7/php.ini \
  && sed -i 's/;clear_env = .*/clear_env = no/i' /etc/php7/php-fpm.d/www.conf \
  && sed -i 's/user = .*/user = www-data/i' /etc/php7/php-fpm.d/www.conf \
  && sed -i 's/group = .*/group = www-data2/i' /etc/php7/php-fpm.d/www.conf \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz \
  && apk del $BUILD_ONLY_DEPS \
  && rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /var/tmp/*

COPY ./nginx.conf /etc/nginx/http.d/default.conf
COPY ./s6-rc.d /etc/s6-overlay/s6-rc.d

EXPOSE 8080
ENTRYPOINT ["/init"]
