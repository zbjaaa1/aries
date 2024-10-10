#!/bin/sh -e
# Copyright 2023 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
# Description: check pkgver/pkgrel bumps, amount of changed pkgs etc
# Options: native
# Use 'native' because it requires git commit history.
# https://postmarketos.org/pmb-ci

if [ "$(id -u)" = 0 ]; then
	set -x

	exec su "${TESTUSER:-pmos}" -c "sh -e $0"
fi

.ci/lib/check_changed_aports_versions.py
