#!/bin/sh
# vim: set ts=4:
#
# This is the default ACPI handler script that is configured in
# /etc/acpi/events/anything to be called for every ACPI event.
# You can edit it and add your own actions; treat it as a configuration file.
#
PATH="/usr/share/acpid:$PATH"
alias log='logger -t acpid'

# <dev-class>:<dev-name>:<notif-value>:<sup-value>
case "$1:$2:$3:$4" in

button/power:PWRF:* | button/power:PBTN:*)
	log 'Power button pressed'
	# If we have a lid (notebook), suspend to RAM, otherwise power off.
	if [ -e /proc/acpi/button/lid/LID ]; then
		zzz
	else
		poweroff
	fi
;;
button/sleep:SLPB:*)
	log 'Sleep button pressed'
	# Suspend to RAM.
	zzz
;;
button/lid:*:close:*)
	log 'Lid closed'
	# Suspend to RAM if AC adapter is not connected.
	power-supply-ac || zzz
;;
ac_adapter:*:*:*0)
	log 'AC adapter unplugged'
	# Suspend to RAM if notebook's lid is closed.
	lid-closed && zzz
;;
esac

exit 0
