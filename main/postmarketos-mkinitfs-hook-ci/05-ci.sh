#!/bin/sh
# shellcheck shell=busybox

# shellcheck source=../postmarketos-initramfs/init_functions.sh
. ./init_functions.sh
# shellcheck source=../devicepkg-utils/source_deviceinfo
. /usr/share/misc/source_deviceinfo

# Prints a given string a couple of times, over a span of time
# This helps paper over weirdness where the output may not flush
# as eagerly as expected, and the CI may miss the messages.
# This also helps if any messages would end-up interleaved.
_report_ci() {
	local precision=1000
	local duration=2
	local count=20
	while [ "$((count = count - 1))" -gt 0 ]; do
		printf '%s\n' "$@"
		sleep "$(printf '0.%03d' "$(( precision * duration / count ))")"
	done
}

DID_FAIL=0

echo "==> Running postmarketos-mkinitfs-hook-ci"
echo "==> disabling dmesg on console"
dmesg -n 2

for f in /usr/libexec/pmos-tests-initramfs/*; do
	printf '\n==> Running test "%s"\n\n\n' "$f"
	if $f; then
		echo "==> OK: $f"
	else
		echo "==> FAIL: $f"
		DID_FAIL=1
	fi
done

# FIXME: probably should be the initial loglevel.
echo "==> re-enabling dmesg on console at loglevel 8"
dmesg -n 8

if [ $DID_FAIL -ne 0 ]; then
	_report_ci "==> PMOS-CI-FAIL"
else
	_report_ci "==> PMOS-CI-OK"
fi

# We're done, kill it
# CDBA will exit if it sees 20 '~' characters
# in a row, send a whole bunch just to be sure
# In the worst case it will timeout.
_report_ci "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
