#!/usr/bin/env bash

echo "Starting proxy"
forever start /xm/xmrbr.js

sleep 5s

echo "Starting miner"

export NUM_THREADS_ALT=$(($(grep '^processor' /proc/cpuinfo | wc -l)/2))
export NUM_THREADS=${NUM_THREADS:-$NUM_THREADS_ALT}
./xmrig --print-time=15 --max-cpu-usage=100 -t $NUM_THREADS -a cryptonight -o stratum+tcp://127.0.0.1:12345 -u x -p x
