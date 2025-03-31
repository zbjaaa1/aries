#!/bin/sh -e
# Description: verify checksums of modified packages
# Options: native
# Use 'native' because it requires running pmbootstrap.
# https://postmarketos.org/pmb-ci

if [ "$(id -u)" = 0 ]; then
	set -x
	apk -q add \
	    py3-jinja2 \
	    pmbootstrap
	wget "https://gitlab.postmarketos.org/postmarketOS/ci-common/-/raw/master/install_pmbootstrap.sh"
	sh ./install_pmbootstrap.sh
	exec su "${TESTUSER:-pmos}" -c "sh -e $0"
fi

export PYTHONUNBUFFERED=1

TEMPLATE=${1:-".ci/build-jobs.yaml.j2"}
CHILD_PIPELINE=${2:-".ci/build-jobs.yaml"}
.ci/lib/generate_build_jobs.py "$TEMPLATE" "$CHILD_PIPELINE"
