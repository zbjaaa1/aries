#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

case "$1" in
	pre-commit)
		;;
	post-commit)
		if command -v alpine-appstream-downloader ; then
			alpine-appstream-downloader
		fi
esac
