#!/bin/bash

LOG_FILE="/tmp/$(basename ${0%.sh}.log)"

(

set -x

log_entry(){
	logger -t "$(basename ${0%.sh})" $1
}

die(){
	echo -e "$1"
	log_entry "$1"
	exit $2
}

# Get GRUB2 config file from symlinks in /etc
#
get_grub2_cfgfile(){
	case $DIST_ID in
		Fedora)
			if [ -e /etc/grub2.cfg ]; then
				grub2_cfg_file=/etc/grub2.cfg
			else
				grub2_cfg_file=/etc/grub2-efi.cfg
			fi
			;;
		Ubuntu)
			grub2_cfg_file=/boot/grub/grub.cfg
			;;
		*)
			;;
	esac
<<<<<<< HEAD:local/bin/reboot-to-windows.sh
	readlink -f $grub2_cfg_file
=======

	if [ -e $grub2_bios_file ] ; then
		readlink -f $grub2_bios_file
	elif [ -e $grub2_efi_file ]; then
		readlink -f $grub2_efi_file
	fi
>>>>>>> ff604b2b627608e3d08ca5851a850e7a67d8491b:usr/local/bin/reboot-to-windows.sh
}

# Get first Windows entry from Grub config files
#
get_1st_window_entry(){
	local grub2_cfg_path=$(dirname $GRUB2_CFG_FILE)
	awk -F\' '/menuentry / {print $2}' $grub2_cfg_path/*.cfg | \
grep -m1 Windows
}

# Get GRUB2 next boot entry
#
get_grub2_next_entry(){
	case $DIST_ID in
		Fedora)
			grub2-editenv list | awk -F'=' '/next_entry/ {print $2}'
			;;
		Ubuntu)
			grub-editenv list | awk -F'=' '/next_entry/ {print $2}'
			;;
		*)
			;;
	esac
}


DIST_ID=$(lsb_release -s -i)

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
GRUB2_CFG_FILE=$(get_grub2_cfgfile)

# If we pass the entry name as argument, we override the 1st Windows
# entry detection.
#
if [ $# -eq 0 ]; then
	WINDOWS_ENTRY="$(get_1st_window_entry)"
else
	WINDOWS_ENTRY=$1
fi

# Exit if we don't find any Windows entry in the GRUB2 config files
if [ "$WINDOWS_ENTRY" == '' ]; then
	die "No Windows entry found in GRUB2 config files. Quitting." 2
fi

# Force GRUB2 to boot $WINDOWS_ENTRY on next boot and get the value of
# next_entry afterwards.
#
case $DIST_ID in
	Fedora)
		grub2-reboot "$WINDOWS_ENTRY"
		;;
	Ubuntu)
		grub-reboot "$WINDOWS_ENTRY"
		;;
	*)
		;;
esac

GRUB2_NEXT_ENTRY=$(get_grub2_next_entry)

# Check if setting next boot entry to $WINDOWS_ENTRY succedeed and trigger
# a reboot.
#
if [ "$GRUB2_NEXT_ENTRY" == "$WINDOWS_ENTRY" ]; then
	log_entry "Succesfully set next_entry to $WINDOWS_ENTRY"
	log_entry "Rebooting to $WINDOWS_ENTRY" 0
	reboot
else
	die "Something failed setting next_entry to $WINDOWS_ENTRY. \
Check $LOG_FILE for details." 1
fi

) 2>&1 | tee -a $LOG_FILE
