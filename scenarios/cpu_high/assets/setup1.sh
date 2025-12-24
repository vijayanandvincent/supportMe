#!/bin/bash
apt update -y
apt install -y stress sysstat

# Start CPU load
stress --cpu 2 --timeout 1200 &
