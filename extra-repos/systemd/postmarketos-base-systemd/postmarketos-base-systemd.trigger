#!/bin/sh

# system units
systemctl preset-all

# session/user units
systemctl --global preset-all

cat <<EOF
---------------------------------------------------------------------------------------------------------
HINT: To permanently DISABLE a systemd unit, use: systemctl mask <unit>
HINT: To permanently ENABLE a systemd unit, add a preset for it in the appropriate /etc/systemd/*-preset
---------------------------------------------------------------------------------------------------------
EOF
