help:
	echo 'Run "sudo make install" to install the program'
	echo 'Run "sudo make run" to run the program'
	echo 'Run "sudo make uninstall" to uninstall the program'
install: build
	sudo gdebi --non-interactive tinyCameraMonitor_UNSTABLE.deb
run:
	python tinyCameraMonitor.sh
uninstall:
	sudo apt-get purge tinyCameraMonitor
build: 
	sudo make build-deb;
build-deb:
	# make directories
	mkdir -p debian/DEBIAN
	mkdir -p debian/usr/bin
	mkdir -p debian/etc
	mkdir -p debian/usr/share/applications
	mkdir -p debian/etc/xdg/autostart
	mkdir -p ./debian/usr/share/tinyCameraMonitor
	# copy over launcher so it will show in the menu
	cp tinyCameraMonitor.desktop ./debian/usr/share/applications/tinyCameraMonitor.desktop
	# copy over launcher to autostart on user login
	cp tinyCameraMonitor.desktop ./debian/etc/xdg/autostart/tinyCameraMonitor.desktop
	# copy icons to system
	cp tinyCameraMonitor.svg ./debian/usr/share/tinyCameraMonitor/tinyCameraMonitor.svg
	cp tinyCameraMonitor_off.svg ./debian/usr/share/tinyCameraMonitor/tinyCameraMonitor_off.svg
	# copy config file to etc
	cp tinyCameraMonitor.cfg debian/etc/
	# copy over executables
	cp tinyCameraMonitor.sh ./debian/usr/bin/tinyCameraMonitor
	cp tinyCameraMonitorGTK.py ./debian/usr/bin/tinyCameraMonitorGTK
	cp tinyCameraMonitor_daemon.sh ./debian/usr/bin/tinyCameraMonitor_daemon
	# make the scripts executable
	chmod +x ./debian/usr/bin/tinyCameraMonitor
	chmod +x ./debian/usr/bin/tinyCameraMonitorGTK
	chmod +x ./debian/usr/bin/tinyCameraMonitor_daemon
	# create the md5sums file
	find ./debian/ -type f -print0 | xargs -0 md5sum > ./debian/DEBIAN/md5sums
	# cut filenames of extra junk
	sed -i.bak 's/\.\/debian\///g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*\\n//g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*//g' ./debian/DEBIAN/md5sums
	rm -v ./debian/DEBIAN/md5sums.bak
	# figure out the package size
	du -sx --exclude DEBIAN ./debian/ > Installed-Size.txt
	# copy over package data
	cp -rv .debdata/. debian/DEBIAN/
	# fix permissions in package
	chmod -Rv 775 debian/DEBIAN/
	chmod -Rv ugo+r debian/
	chmod -Rv go-w debian/
	chmod -Rv u+w debian/
	# build the package
	dpkg-deb --build debian
	cp -v debian.deb tinyCameraMonitor_UNSTABLE.deb
	rm -v debian.deb
	rm -rv debian
