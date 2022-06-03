#!/bin/bash

if command -v ip > /dev/null 2>&1; then
	echo 'Running ip -o -f inet addr show | awk ''/scope global/ {print $4}'' to find your local subnet(s)'
	ip -o -f inet addr show | awk '/scope global/ {print $4}'
else
	echo "Cannot detect your local subnet(s) - you will have to do that manually"
fi
echo ""
echo "Here is a command to run to scan your local network.  Be sure to fill in your subnet as per the example:"
echo "nmap -Pn -sT [/24 cidr] # eg nmap -Pn -sT 10.0.0.1/24"
