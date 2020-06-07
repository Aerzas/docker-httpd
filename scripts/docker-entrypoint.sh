#!/bin/sh
set -e

# Index
if [ -z "${HTTPD_VHOST_INDEX_FILE}" ]; then
  if [ "${HTTPD_VHOST_PRESET}" = php ] || [ "${HTTPD_VHOST_PRESET}" = drupal8 ]; then
    export HTTPD_VHOST_INDEX_FILE='index.php'
  elif [ "${HTTPD_VHOST_PRESET}" = default ]; then
    export HTTPD_VHOST_INDEX_FILE='index.html'
  fi
fi

# HTTP2
if [ "${HTTPD_VHOST_HTTP2}" = true ]; then
  export HTTPD_VHOST_PROTOCOLS='Protocols h2c http/1.1'
else
  export HTTPD_VHOST_PROTOCOLS=
fi

# Replace environment variables in template files
envs=$(printf '${%s} ' "$(sh -c \"env | cut -d'=' -f1\")")
find /usr/local/apache2/conf -name '*.tmpl' \
  -exec sh -c 'filename="$1"; envsubst "${envs}" <"${filename}" >"${filename%?????}"' \
  -exec rm {} \;

exec "$@"
