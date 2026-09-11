#!/bin/sh -eu

# Installs the gfortran alpine currently packages, and records which that
# turned out to be.

apk add --no-cache gc g++ gfortran

# Read by check_version.sh, so the gate states the version this image holds
# rather than one written down when someone last edited it. -dumpfullversion
# prints the version alone, where --version prints a sentence around it.
echo "{\"gfortran\":\"$(gfortran -dumpfullversion)\"}" > /versions.json
