#!/bin/sh
set -e

build_version="${1}"
build_httpd_version="${2}"
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2
  exit 1
fi

registry_image='aerzas/httpd'

httpd_base_tag() {
  httpd_version="${1}"
  if [ -z "${httpd_version}" ]; then
    echo 'HTTPD version is required' >&2
    return 1
  fi

  case ${httpd_version} in
  2.4)
    echo httpd:2.4.43-alpine
    ;;
  *)
    return 0
    ;;
  esac
}

build_httpd() {
  httpd_version="${1}"
  if [ -z "${httpd_version}" ]; then
    echo 'Build HTTPD version is required' >&2
    return 1
  fi
  if [ -z "$(httpd_base_tag ${httpd_version})" ]; then
    echo 'Build HTTPD version is invalid' >&2
    return 1
  fi

  echo "$(printf '\033[32m')Build HTTPD image ${httpd_version}$(printf '\033[m')"

  # Build image
  docker build \
    --build-arg BUILD_HTTPD_IMAGE="$(httpd_base_tag ${httpd_version})" \
    -t "${registry_image}:${httpd_version}-${build_version}" \
    -f Dockerfile \
    . \
    --no-cache

  # Push image
  docker push "${registry_image}:${httpd_version}-${build_version}"

  # Remove local image
  docker image rm "${registry_image}:${httpd_version}-${build_version}"
}

# Build single HTTPD version
if [ -n "${build_httpd_version}" ]; then
  build_httpd "${build_httpd_version}"
# Build all HTTPD versions
else
  build_httpd 2.4
fi
