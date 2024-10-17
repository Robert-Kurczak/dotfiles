#!/bin/bash

SELECTION="$(printf "Log out\nSuspend\nReboot\nShutdown" | fuzzel --dmenu -l 4)"

case $SELECTION in
	*"Suspend")
		systemctl suspend;;
	*"Log out")
		hyprctl dispatch exit;;
	*"Reboot")
		systemctl reboot;;
	*"Shutdown")
		systemctl poweroff;;
esac
