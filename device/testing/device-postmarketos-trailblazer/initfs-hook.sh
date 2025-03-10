#!/bin/sh

# enable adsp for dp-alt,
# this requires remoteproc[0,1] to be started (qcadsp8380.mbn)
if [ -d /sys/class/remoteproc/remoteproc0 ]; then
	echo "start" | tee /sys/class/remoteproc/remoteproc0/state
fi
if [ -d /sys/class/remoteproc/remoteproc1 ]; then
	echo "start" | tee /sys/class/remoteproc/remoteproc1/state
fi
