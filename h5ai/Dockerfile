FROM alpine:3.15

LABEL org.opencontainers.image.title="h5ai"
LABEL org.opencontainers.image.description="A modern HTTP web server index for Apache httpd, lighttpd, and nginx"
LABEL org.opencontainers.image.source="https://github.com/lrsjng/h5ai"
LABEL org.opencontainers.image.authors="Christoph Heiss <contact@christoph-heiss.at"
LABEL org.opencontainers.image.url="https://github.com/christoph-heiss/docker-images"

ARG H5AI_VERSION

WORKDIR /app

RUN \
  BUILD_ONLY_DEPS="xz" \
  && apk --no-cache upgrade \
  && apk --no-cache add \
    php7 php7-fpm php7-json php7-session php7-gd php7-exif \
    ffmpeg imagemagick nginx $BUILD_ONLY_DEPS \
  && wget -P /tmp https://release.larsjung.de/h5ai/h5ai-$H5AI_VERSION.zip \
  && unzip /tmp/h5ai-$H5AI_VERSION.zip \
  && adduser -S -u 1000 -H -G www-data www-data \
  && chown -R www-data:www-data . \
  && sed -i 's/worker_processes .*;/worker_processes 1;/' /etc/nginx/nginx.conf \
  && sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php7/php.ini \
  && sed -i 's/user = .*/user = www-data/' /etc/php7/php-fpm.d/www.conf \
  && sed -i 's/group = .*/group = www-data/' /etc/php7/php-fpm.d/www.conf \
  # h5ai does not allow setting the data root directory, but rather assumes it is the directory
  # the `_h5ai` folder resides in - which might make sense in simple setups, but when using
  # it inside a container, we want it to use another directory, which cat be mounted into
  # the container.
  # Thus we have to patch the file root path to match our setup.
  && sed -i \
    "s/\$this->set('ROOT_PATH', Util::normalize_path(dirname(\$this->get('H5AI_PATH')), false));/\$this->set('ROOT_PATH', '\/data');/" \
    _h5ai/private/php/core/class-setup.php \
  && wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-x86_64.tar.xz \
  && wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.1/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz \
  && apk del $BUILD_ONLY_DEPS \
  && rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /var/tmp/*

COPY ./nginx.conf /etc/nginx/http.d/default.conf
COPY ./s6-rc.d /etc/s6-overlay/s6-rc.d

EXPOSE 80
ENTRYPOINT ["/init"]
