ARG BUILD_HTTPD_IMAGE

FROM ${BUILD_HTTPD_IMAGE}

ENV APP_ROOT="/var/www/html"

RUN set -ex; \
    # Install envsubst
    apk add --update libintl; \
    apk add --no-cache --virtual .gettext gettext; \
    cp /usr/bin/envsubst /usr/local/bin/envsubst; \
    apk del .gettext; \
    # Cleanup
    rm -Rf \
        ${HTTPD_PREFIX}/conf/extra \
        ${HTTPD_PREFIX}/conf/magic \
        ${HTTPD_PREFIX}/conf/original; \
    # Prepare base folders
    mkdir -p \
        ${APP_ROOT} \
        ${HTTPD_PREFIX}/conf/extra \
        ${HTTPD_PREFIX}/conf/presets; \
    # Execute httpd as any user
    chgrp -R 0 \
        ${HTTPD_PREFIX} \
        ${APP_ROOT}; \
    chmod -R g+rwX \
        ${HTTPD_PREFIX} \
        ${APP_ROOT}

ENV HTTPD_BACKEND_HOST=php \
    HTTPD_BACKEND_PORT=9000 \
    HTTPD_DOCUMENT_CACHE_CONTROL='"public"' \
    HTTPD_DOCUMENT_EXPIRES_ACTIVE=On \
    HTTPD_DOCUMENT_EXPIRES_DEFAULT='"access plus 1 days"' \
    HTTPD_DOCUMENT_PRAGMA='"cache"' \
    HTTPD_FCGI_PROXY_CONNECT_TIMEOUT=1 \
    HTTPD_FCGI_PROXY_TIMEOUT=10 \
    HTTPD_HOSTNAME_LOOKUPS=Off \
    HTTPD_KEEPALIVE=On \
    HTTPD_KEEPALIVE_REQUESTS=100 \
    HTTPD_KEEPALIVE_TIMEOUT=75 \
    HTTPD_LOG_CUSTOM='/proc/self/fd/1 common env=!nolog' \
    HTTPD_LOG_ERROR=/proc/self/fd/2 \
    HTTPD_LOG_FORMAT='%h %l %u %t \"%r\" %>s %b' \
    HTTPD_LOG_LEVEL=warn \
    HTTPD_MPM_MAX_CLIENTS=400 \
    HTTPD_MPM_THREAD_LIMIT=64 \
    HTTPD_MPM_THREADS_PER_CHILD=25 \
    HTTPD_MPM_SERVER_LIMIT=16 \
    HTTPD_MPM_START_SERVERS=3 \
    HTTPD_REQUEST_WORKERS=100 \
    HTTPD_SERVER_ADMIN=root@localhost \
    HTTPD_SERVER_NAME=localhost \
    HTTPD_SERVER_SIGNATURE=Off \
    HTTPD_SERVER_TOKENS=Prod \
    HTTPD_STATIC_CACHE_CONTROL='"public"' \
    HTTPD_STATIC_EXPIRES_ACTIVE=On \
    HTTPD_STATIC_EXPIRES_DEFAULT='"access plus 7 days"' \
    HTTPD_STATIC_PRAGMA='"cache"' \
    HTTPD_TIMEOUT=10 \
    HTTPD_TIMEOUT_REQUEST='handshake=5 header=10 body=10' \
    HTTPD_TRACE_ENABLE=Off \
    HTTPD_USE_CANONICAL_NAME=Off \
    HTTPD_VHOST_ALLOW_OVERRIDE=None \
    HTTPD_VHOST_HTTP2=true \
    HTTPD_VHOST_INDEX_FILE='' \
    HTTPD_VHOST_OPTIONS=FollowSymLinks \
    HTTPD_VHOST_PRESET=default \
    HTTPD_VHOST_ROOT=/var/www/html

USER 1001

COPY conf/*.tmpl /usr/local/apache2/conf/
COPY conf/extra/*.tmpl /usr/local/apache2/conf/extra/
COPY conf/presets/*.tmpl /usr/local/apache2/conf/presets/
COPY scripts/*.sh /scripts/

WORKDIR $APP_ROOT
EXPOSE 8080

STOPSIGNAL SIGWINCH

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["httpd-foreground"]
