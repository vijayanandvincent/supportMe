#!/bin/bash



apt update -y
apt install -y stress sysstat
stress --cpu 2 --timeout 600 &

