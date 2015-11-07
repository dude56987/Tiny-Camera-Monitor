#! /bin/bash
# set active to false
active=false
device=$(cat /etc/tinyCameraMonitor.cfg)
while true;do
	# check status in 5 second intervals
	sleep 5
	if fuser $(cat /etc/tinyCameraMonitor.cfg);then
		# if message has not been sent yet send message once
		if ! $active;then
			notify-send --icon="/usr/share/tinyCameraMonitor/tinyCameraMonitor.svg" "Camera is ON
Activated: $device";
			# activate the gtk icon as a thread
			tinyCameraMonitorGTK &
			# set flag to true
			active=true
		fi
	else
		# if camera is no longer active but was previously send message and change status
		if $active;then
			notify-send --icon="/usr/share/tinyCameraMonitor/tinyCameraMonitor_off.svg" "Camera is OFF
Deactivated: $device";
			# deactivate the gtk icon
			killall tinyCameraMonitorGTK
			# set flag to false
			active=false
		fi
	fi

done
