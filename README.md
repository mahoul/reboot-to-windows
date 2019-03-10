# reboot-to-windows

## Description

Simple script, desktop and sudo rule to simplify the ease rebooting into Windows
without selecting it by hand on the next reboot.

## Installation

Lazy and ugly method

```sh
# Test rsync
for i in etc usr; do sudo rsync -navP $i /; done

# Do it!
for i in etc usr; do sudo rsync -avP $i /; done
```

## Requirements

- GRUB2
- __GRUB\_DEFAULT__ set to __saved__
- User member of __wheel__ group (Fedora/RHEL based only)

## Use

By default, the script looks for _GRUB2_ menu list entries starting with __'Windows'__ and
(if found) sets __next\_entry__ to boot it on the next boot.  
Should work for any other entry provided that full name is specified in file usr/local/share/applications/reboot-to-windows.desktop.

Example:
```Ini
[Desktop Entry]
Type=Application
Version=1.0
Name=Reboot to Windows
Comment=Reboot to Windows
Exec=sudo reboot-to-windows.sh "Windows To Go USB"
Icon=Windows_logo_-_2012
Terminal=false
StartupNotify=true
```


## TO-DO

Only tested on Fedora, may require minor changes to work on other distros.
