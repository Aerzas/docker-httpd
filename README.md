# HTTPD

HTTPD docker container image that requires no specific user or root permission to function.

Image comes with presets:
- `default`: serve static files
- `php`: proxy requests to a PHP-FPM backend

Docker Hub image: [https://hub.docker.com/r/aerzas/httpd](https://hub.docker.com/r/aerzas/httpd)

## Docker compose example

```yaml
version: '3.5'
services:
    php:
        image: aerzas/httpd:2.4-1.0.1
        environment:
            HTTPD_VHOST_ALLOW_OVERRIDE: All
            HTTPD_VHOST_PRESET: php
            HTTPD_VHOST_ROOT: /var/www/html/web
        ports:
            - '80:8080'
        healthcheck:
            test: ["CMD", "/scripts/docker-healthcheck.sh"]
            interval: 30s
            timeout: 1s
            retries: 3
            start_period: 5s
```

Additional extra configuration files can be mounted in `/usr/local/apache2/conf/extra` while additional presets should
be mounted in `/usr/local/apache2/conf/presets`, files mounted as `.tmpl` will have their environment variables
automatically replaced.

## Environment Variables

| Variable | Default Value
| --- | ---
| **Server**
| `HTTPD_HOSTNAME_LOOKUPS` | `Off`
| `HTTPD_KEEPALIVE` | `On`
| `HTTPD_KEEPALIVE_REQUESTS` | `100`
| `HTTPD_KEEPALIVE_TIMEOUT` | `75`
| `HTTPD_REQUEST_WORKERS` | `100`
| `HTTPD_SERVER_ADMIN` | `root@localhost`
| `HTTPD_SERVER_NAME` | `localhost`
| `HTTPD_SERVER_SIGNATURE` | `Off`
| `HTTPD_SERVER_TOKENS` | `Prod`
| `HTTPD_TIMEOUT` | `10`
| `HTTPD_TIMEOUT_REQUEST` | `handshake=5 header=10 body=10`
| `HTTPD_TRACE_ENABLE` | `Off`
| `HTTPD_USE_CANONICAL_NAME` | `Off`
| **Log**
| `HTTPD_LOG_CUSTOM` | `/proc/self/fd/1 common env=!nolog`
| `HTTPD_LOG_ERROR` | `/proc/self/fd/2`
| `HTTPD_LOG_FORMAT` | `'%h %l %u %t \"%r\" %>s %b'`
| `HTTPD_LOG_LEVEL` | `warn`
| **Multi-processing modules**
| `HTTPD_MPM_MAX_CLIENTS` | `400`
| `HTTPD_MPM_THREAD_LIMIT` | `64`
| `HTTPD_MPM_THREADS_PER_CHILD` | `25`
| `HTTPD_MPM_SERVER_LIMIT` | `16`
| `HTTPD_MPM_START_SERVERS` | `3`
| **Static**
| `HTTPD_DOCUMENT_CACHE_CONTROL` | `"public"`
| `HTTPD_DOCUMENT_EXPIRES_ACTIVE` | `On`
| `HTTPD_DOCUMENT_EXPIRES_DEFAULT` | `"access plus 1 days"`
| `HTTPD_DOCUMENT_PRAGMA` | `"cache"`
| `HTTPD_STATIC_CACHE_CONTROL` | `"public"`
| `HTTPD_STATIC_EXPIRES_ACTIVE` | `On`
| `HTTPD_STATIC_EXPIRES_DEFAULT` | `"access plus 7 days"`
| `HTTPD_STATIC_PRAGMA` | `"cache"`
| **Vhost**
| `HTTPD_VHOST_ALLOW_OVERRIDE` | `None`
| `HTTPD_VHOST_HTTP2` | `true`
| `HTTPD_VHOST_INDEX_FILE`
| `HTTPD_VHOST_OPTIONS` | `FollowSymLinks`
| `HTTPD_VHOST_PRESET` | `default`
| `HTTPD_VHOST_ROOT` | `/var/www/html`
| **Preset "php"**
| `HTTPD_BACKEND_HOST` | `php`
| `HTTPD_BACKEND_PORT` | `9000`
| `HTTPD_FCGI_PROXY_CONNECT_TIMEOUT` | `1`
| `HTTPD_FCGI_PROXY_TIMEOUT` | `10`
