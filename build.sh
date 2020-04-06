#!/bin/sh
set -e;

build_version="${1}";
build_httpd_version="${2}";
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2;
  exit 1;
fi;

registry_image='aerzas/httpd';
declare -A httpd_versions=(
  [2.4]=httpd:2.4.43-alpine
);

build_httpd()
{
  httpd_version="${1}";
  if [ -z "${httpd_version}" ]; then
    echo 'Build HTTPD version is required' >&2;
    return 1;
  fi;
  if [ -z "${httpd_versions[${httpd_version}]}" ]; then
    echo 'Build HTTPD version is invalid' >&2;
    return 1;
  fi;

  echo -e "\e[32mBuild HTTPD image ${httpd_version}\e[0m";

  # Build image
  docker build \
    --build-arg BUILD_HTTPD_IMAGE=${httpd_versions[${httpd_version}]} \
    -t ${registry_image}:${httpd_version}-${build_version} \
    -f Dockerfile \
    . \
    --no-cache;

  # Push image
  docker push ${registry_image}:${httpd_version}-${build_version};

  # Remove local image
  docker image rm ${registry_image}:${httpd_version}-${build_version};
}

# Build single HTTPD version
if [ ! -z "${build_httpd_version}" ]; then
  build_httpd ${build_httpd_version};
# Build all HTTPD versions
else
  for httpd_version in "${!httpd_versions[@]}"; do
    build_httpd ${httpd_version};
  done;
fi;
