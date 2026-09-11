#!/usr/bin/env bash
set -Eeu

readonly REGEX="image_name\": \"(.*)\""
readonly JSON=`cat docker/image_name.json`
[[ ${JSON} =~ ${REGEX} ]]
readonly IMAGE_NAME="${BASH_REMATCH[1]}"

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# The image records the gfortran alpine packaged for it in /versions.json, so
# the expected version is read from the image rather than written down here.
# Writing it down here would pin the image to whatever alpine happened to be
# packaging when someone last edited this file.
readonly VERSIONS=$(docker run --rm -i ${IMAGE_NAME} sh -c 'cat /versions.json')
readonly VERSION_REGEX='"gfortran":"([0-9.]+)"'
if [[ ! ${VERSIONS} =~ ${VERSION_REGEX} ]]; then
  echo "VERSION ERROR: /versions.json has no gfortran property"
  echo "VERSION   FILE: ${VERSIONS}"
  exit 42
fi
readonly EXPECTED="${BASH_REMATCH[1]}"

# Asks the installed compiler, so the gate fails if the number recorded at
# build time is not the gfortran the image can actually run.
readonly ACTUAL=$(docker run --rm -i ${IMAGE_NAME} sh -c 'gfortran -dumpfullversion')

if [ "${ACTUAL}" == "${EXPECTED}" ]; then
  echo "VERSION CONFIRMED as ${EXPECTED}"
else
  echo "VERSION EXPECTED: ${EXPECTED}"
  echo "VERSION   ACTUAL: ${ACTUAL}"
  exit 42
fi
