#!/bin/sh -eu

# Installs the gfortran alpine currently packages, and records which that
# turned out to be.

apk add --no-cache gc g++ gfortran

# Read by check_version.sh, so the gate states the version this image holds
# rather than one written down when someone last edited it. -dumpfullversion
# prints the version alone, where --version prints a sentence around it.
readonly GFORTRAN_VERSION=$(gfortran -dumpfullversion)
# The language is named Fortran, as a learner knows it, though the version is
# gfortran's: that is the compiler which implements it here.
cat > /versions.json <<EOF
{
  "language": {
    "name": "Fortran",
    "version": "${GFORTRAN_VERSION}"
  },
  "test_frameworks": []
}
EOF
