#!/bin/bash


echo "SETUP RAN" > /tmp/setup-proof.txt
apt update -y
apt install -y stress sysstat
stress --cpu 2 --timeout 600 &

