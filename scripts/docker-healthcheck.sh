#!/bin/sh
set -e

wget --spider --quiet --tries=1 "http://${HTTPD_SERVER_NAME}:8080/.healthz" && exit 0

exit 1
