#!/bin/bash

echo "dd if=/dev/urandom of=/tmp/test.5mb bs=1024 count=5000 && curl --upload-file /tmp/test.5mb https://paste.c-net.org/"