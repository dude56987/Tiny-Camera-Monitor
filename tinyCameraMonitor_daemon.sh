#! /bin/bash
# run the daemon component of the software
# if ran with a currently running daemon dont relaunch
# check if tinyCameraMonitor is running, if not launch it, this results in a infinte loop
if [ -f /usr/bin/tinyCameraMonitor ]; then
	while ! pgrep -fcx "/bin/bash /usr/bin/tinyCameraMonito[r]";do
		echo "Launching TinyCameraMonitor...";
		tinyCameraMonitor;
	done; 
	echo "TinyCameraMonitor already running...";
fi;

