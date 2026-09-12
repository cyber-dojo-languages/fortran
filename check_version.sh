#!/usr/bin/env bash
set -Eeu

readonly REGEX="image_name\": \"(.*)\""
readonly JSON=`cat docker/image_name.json`
[[ ${JSON} =~ ${REGEX} ]]
readonly IMAGE_NAME="${BASH_REMATCH[1]}"

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Written down here so the gate fails when the floating base image moves to a
# different gfortran. Reading it from the image instead would compare the image
# against itself and pass whatever the move brought in.
readonly EXPECTED=15.2

# Asks the installed compiler, so the gate fails when the gfortran the image
# can actually run is not the one named above. Matching on the leading
# major.minor lets a patch release through and stops only a minor or major move.
readonly ACTUAL=$(docker run --rm -i ${IMAGE_NAME} sh -c 'gfortran -dumpfullversion')

if echo "${ACTUAL}" | grep -q "${EXPECTED}"; then
  echo "VERSION CONFIRMED as ${EXPECTED}"
else
  echo "VERSION EXPECTED: ${EXPECTED}"
  echo "VERSION   ACTUAL: ${ACTUAL}"
  exit 42
fi
