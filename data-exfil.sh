#!/bin/bash

grn=$'\e[1;32m'
end=$'\e[0m'

echo "Here is an example of a command that can be run to simulate transferring a large file to a remote host"
echo ""
echo "Example command:"
echo ""
echo "${grn}dd if=/dev/urandom of=/tmp/test.48mb bs=1024768 count=48 && curl --upload-file /tmp/test.48mb https://paste.c-net.org/${end}"
echo ""
read -p "Press enter to run this command automatically (or ctrl-c to cancel)"
echo ""
sh -c 'dd if=/dev/urandom of=/tmp/test.48mb bs=1024768 count=48'
sh -c 'curl --upload-file /tmp/test.48mb https://paste.c-net.org/'
echo ""
echo "Done!"
