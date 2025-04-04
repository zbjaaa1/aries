#! /bin/sh

set -eu

# FIXME: Don't run this as root...
pmb="pmbootstrap --as-root -y"

if [ "$(id -u)" -ne 0 ]; then
	echo "must be run as root! (FIXME)"
	exit 1
fi

do_prepare() {
	yes '' | $pmb init

	# TODO: allow selecting device in the UI somehow?
	# For now get it from deviceinfo...
	# shellcheck disable=SC1091
	. /usr/share/misc/source_deviceinfo

	if [ -z "$deviceinfo_codename" ]; then
		echo "unable to get device info"
		exit 1
	fi

	$pmb config device "$deviceinfo_codename"
}

do_install() {
	# OSI_DESKTOP             : Desktop keyword, or empty if 'desktop' was not configured
	# OSI_LOCALE              : Locale to be used in the new system
	# OSI_DEVICE_PATH         : Device path at which to install
	# OSI_DEVICE_IS_PARTITION : 1 if the specified device is a partition (0 -> disk)
	# OSI_DEVICE_EFI_PARTITION: Set if device is partition and system uses EFI boot.
	# OSI_USE_ENCRYPTION      : 1 if the installation is to be encrypted
	# OSI_ENCRYPTION_PIN      : The encryption pin to use (if encryption is set)

	$pmb config ui "$OSI_DESKTOP"
	$pmb config keymap "$OSI_KEYBOARD_LAYOUT"
	$pmb config locale "$OSI_LOCALE"
}

do_configure() {
	# The script gets called with the environment variables from the install step
	# and these additional variables:
	# OSI_USER_NAME          : User's name. Not ASCII-fied
	# OSI_USER_USERNAME      : Linux username. ASCII-fied
	# OSI_USER_AUTOLOGIN     : Whether to autologin the user
	# OSI_USER_PASSWORD      : User's password. Can be empty if autologin is set.
	# OSI_FORMATS            : Locale of formats to be used
	# OSI_TIMEZONE           : Timezone to be used
	# OSI_ADDITIONAL_SOFTWARE: Space-separated list of additional packages to install
	# OSI_ADDITIONAL_FEATURES: Space-separated list of additional features chosen

	$pmb config user "$OSI_USER_USERNAME"
	$pmb config timezone "$OSI_TIMEZONE"

	fde_args=""
	if [ -n "$OSI_ENCRYPTION_PIN" ]; then
		fde_args="--fde"
	fi
	PMB_FDE_PASSWORD="$OSI_ENCRYPTION_PIN" $pmb install --password "$OSI_USER_PASSWORD" --disk "$OSI_DEVICE_PATH" $fde_args
}

step="$(basename "$0")"
case "$step" in
install.sh)
	do_install
	;;
prepare.sh)
	do_prepare
	;;
configure.sh)
	do_configure
	;;
*)
	echo "unknown install step: $step"
	exit 1
	;;
esac
